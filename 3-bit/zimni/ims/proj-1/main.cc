#include "simlib.h"

#define OK 0
#define FAIL 1

#define FAILURE_GENERATOR 1000
#define FAILURE_SERVICE 25
#define FAILURE_STATS_COUNT 20
#define FAILURE_STATS_START 0
#define FAILURE_STATS_STEP 10

#define INTERLEAVE_STORE_CAPACITY 10
#define INTERLEAVE_ENTER 1
#define INTERLEAVE_REFILL 7

#define REQUEST_GENERATOR 5
#define REQUEST_SERVICE 3
#define REQUEST_STATS_COUNT 20
#define REQUEST_STATS_START 0
#define REQUEST_STATS_STEP 5

#define START 0
#define STOP 28800

Facility RequestFacility("Request Facility");
Facility FailureFacility("Failure Facility");
Histogram RequestStats("Request Stats", REQUEST_STATS_START, REQUEST_STATS_STEP, REQUEST_STATS_COUNT);
Histogram FailureStats("Failure Stats", FAILURE_STATS_START, FAILURE_STATS_STEP, FAILURE_STATS_COUNT);
Queue RequestQueue("Request Queue");
Store InterleaveStore("Interleave Store", INTERLEAVE_STORE_CAPACITY);

int failure = OK;

class Request : public Process {
	double Arrival;
	void Behavior() {
		Arrival = Time;
		Seize(RequestFacility);
		if(failure) {
			RequestQueue.Insert(this);
			Passivate();
		}
		if(InterleaveStore.Full()) {
			Wait(Exponential(INTERLEAVE_REFILL));
			Leave(InterleaveStore, INTERLEAVE_STORE_CAPACITY);
		}
		Enter(InterleaveStore, INTERLEAVE_ENTER);
		Wait(Exponential(REQUEST_SERVICE));
		Release(RequestFacility);
		RequestStats(Time - Arrival);
	}
};

class Failure : public Process {
	double Arrival;
	void Behavior() {
		Arrival = Time;
		failure = FAIL;
		Wait(Exponential(FAILURE_SERVICE));
		failure = OK;
		if(!RequestQueue.Empty()) {
			RequestQueue.GetFirst()->Activate();
		}
		FailureStats(Time - Arrival);
	}
};

class RequestGenerator : public Event {
	void Behavior() {
		(new Request)->Activate();
		Activate(Time + Exponential(REQUEST_GENERATOR));
	}
};

class FailureGenerator : public Event {
	void Behavior() {
		(new Failure)->Activate();
		Activate(Time + Exponential(FAILURE_GENERATOR));
	}
};

int main() {
	Init(START, STOP);
	(new RequestGenerator)->Activate();
	(new FailureGenerator)->Activate();
	Run();
	RequestFacility.Output();
	FailureFacility.Output();
	RequestStats.Output();
	FailureStats.Output();
	RequestQueue.Output();
	InterleaveStore.Output();
	return OK;
}
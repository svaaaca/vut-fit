/**
 * @file main.cc
 * @author David Kvaček (xkvace00@stud.fit.vutbr.cz)
 * @brief Source code of the IMS course project implementation.
 * @date 2024-12-02
 */

#include "simlib.h"

/**
 * Setting the original constants for the simulation model corresponding to the actual state of the modeled system.
 */

#define OK 0            // successful termination of the simulation

#define START 0         // start time of the simulation
#define END 28800       // end time of the simulation (8 hours)

#define R_TYPE 0.6      // probability of the request type (60 % of regular)
#define F_TYPE 0.8      // probability of the failure type (80 % non-serious)

#define S1_ENTER 1      // number of the entered items to the store S1
#define S2_ENTER 1      // number of the entered items to the store S2

#define H1_FROM 0       // lower bound of the histogram H1
#define H1_NO 20        // number of the histogram H1 intervals

#define H2_FROM 0       // lower bound of the histogram H2
#define H2_NO 20        // number of the histogram H2 intervals

#define FG_MEAN 1800    // mean time between failures

#define R1_MEAN 90      // mean time of the regular request processing
#define R2_MEAN 180     // mean time of the special request processing

#define F1_MEAN 30      // mean time of the non-serious failure processing
#define F2_MEAN 300     // mean time of the serious failure processing

/**
 * Setting the specific constants for the simulation model corresponding to the EXPERIMENT 1.
 */

#define S1_MAX 25       // maximum capacity of the store S1
#define S2_MAX 25       // maximum capacity of the store S2

#define H1_STEP 100     // step of the histogram H1

#define H2_STEP 50      // step of the histogram H2

#define RG_MEAN 180     // mean time between requests

#define R1_ADD 60       // additional time for the regular request processing
#define R2_ADD 120      // additional time for the special request processing

/**
 * Setting the specific constants for the simulation model corresponding to the EXPERIMENT 2.
 */

// #define S1_MAX 25       // maximum capacity of the store S1
// #define S2_MAX 25       // maximum capacity of the store S2

// #define H1_STEP 100     // step of the histogram H1

// #define H2_STEP 10      // step of the histogram H2

// #define RG_MEAN 150     // mean time between requests

// #define R1_ADD 60       // additional time for the regular request processing
// #define R2_ADD 120      // additional time for the special request processing

/**
 * Setting the specific constants for the simulation model corresponding to the EXPERIMENT 3.
 */

// #define S1_MAX 50       // maximum capacity of the store S1
// #define S2_MAX 50       // maximum capacity of the store S2

// #define H1_STEP 50      // step of the histogram H1

// #define H2_STEP 30      // step of the histogram H2

// #define RG_MEAN 150     // mean time between requests

// #define R1_ADD 60       // additional time for the regular request processing
// #define R2_ADD 120      // additional time for the special request processing

/**
 * Setting the specific constants for the simulation model corresponding to the EXPERIMENT 4.
 */

// #define S1_MAX 50       // maximum capacity of the store S1
// #define S2_MAX 50       // maximum capacity of the store S2

// #define H1_STEP 50      // step of the histogram H1

// #define H2_STEP 20      // step of the histogram H2

// #define RG_MEAN 120     // mean time between requests

// #define R1_ADD 45       // additional time for the regular request processing
// #define R2_ADD 90       // additional time for the special request processing

/**
 * Definition of the global simulation model objects.
 */

Facility F1("Obsluzna linka vstupnich pozadavku");                              // facility of the request processing
Queue Q1("Fronta vstupnich pozadavku");                                         // queue of the requests
Store S1("Sklad prokladovych list 1", S1_MAX);                                  // store of the regular requests
Store S2("Sklad prokladovych list 2", S2_MAX);                                  // store of the special requests
Histogram H1("Cetnost hodnot doby obsluhy pozadavku", H1_FROM, H1_STEP, H1_NO); // histogram of the request processing time
Histogram H2("Cetnost hodnot doby opravy poruchy", H2_FROM, H2_STEP, H2_NO);    // histogram of the failure processing time

/**
 * Definition of the global simulation model variables.
 */

bool failure = false;   // flag of the failure state

/**
 * Definition of the global simulation model processes.
 */

class Request : public Process {
    double Arrival;
    void Behavior() {
        Arrival = Time;
        if (failure) {
            Q1.Insert(this);
            Passivate();
        }

        Seize(F1);
        if (Random() < R_TYPE) {
            if (S1.Full()) {
                Wait(Exponential(R1_ADD));
                Leave(S1, S1_MAX);
            }

            Enter(S1, S1_ENTER);
            Wait(Exponential(R1_MEAN));
        }

        else {
            if (S2.Full()) {
                Wait(Exponential(R2_ADD));
                Leave(S2, S2_MAX);
            }

            Enter(S2, S2_ENTER);
            Wait(Exponential(R2_MEAN));
        }

        Release(F1);
        H1(Time - Arrival);
    }
};

class Failure : public Process {
    double Arrival;
    void Behavior() {
        Arrival = Time;
        failure = true;
        if (Random() < F_TYPE) {
            Wait(Exponential(F1_MEAN));
        }

        else {
            Wait(Exponential(F2_MEAN));
        }

        failure = false;
        if (!Q1.Empty()) {
            Q1.GetFirst()->Activate();
        }

        H2(Time - Arrival);
    }
};

/**
 * Definition of the global simulation model events.
 */

class RequestGenerator : public Event {
    void Behavior() {
        (new Request)->Activate();
        Activate(Time + Exponential(RG_MEAN));
    }
};

class FailureGenerator : public Event {
    void Behavior() {
        (new Failure)->Activate();
        Activate(Time + Exponential(FG_MEAN));
    }
};

/**
 * Main function of the simulation model.
 */

int main() {
    Init(START, END);                   // initialize the simulation model

    (new RequestGenerator)->Activate(); // activate the request generator
    (new FailureGenerator)->Activate(); // activate the failure generator

    Run();                              // run the simulation model

    F1.Output();                        // output the facility F1 statistics
    Q1.Output();                        // output the queue Q1 statistics
    S1.Output();                        // output the store S1 statistics
    S2.Output();                        // output the store S2 statistics
    H1.Output();                        // output the histogram H1 statistics
    H2.Output();                        // output the histogram H2 statistics

    return OK;
}

#!/usr/bin/env python3

import collections
import functools

def log_and_count(*, key = None, counts):
    def decorator(func):
        @functools.wraps(func)
        def wrapper(*args, **kwargs):
            # Log the function call
            print(f"called {func.__name__} with {args} and {kwargs}")
            # Increment the counter based on the provided key or function name
            counts[key or func.__name__] += 1
            return func(*args, **kwargs)
        return wrapper
    return decorator

my_counter = collections.Counter()

@log_and_count(key = 'basic functions', counts = my_counter)
def f1(a, b = 2):
    return a ** b

@log_and_count(key = 'basic functions', counts = my_counter)
def f2(a, b = 3):
    return a ** 2 + b

@log_and_count(counts = my_counter)
def f3(a, b = 5):
    return a ** 3 - b

f1(2)
f2(2, b = 4)
f1(a = 2, b = 4)
f2(4)
f2(5)
f3(5)
f3(5, 4)

print(my_counter)

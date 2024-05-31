# minitask 7

import functools

def deprecated(func):
    @functools.wraps(func)
    def wrapper(*args, **kwargs):
        print(f"Call to deprecated function: {func.__name__}")
        print(f"with args: {args}")
        print(f"with kwargs: {kwargs}")
        result = func(*args, **kwargs)
        print(f"returning: {result}")
        return result
    return wrapper

@deprecated
def some_old_function(x, y):
    return x + y

some_old_function(1, y = 2)

# should print:
# Call to deprecated function: some_old_function
# with args: (1,)
# with kwargs: {'y': 2}
# returning: 3 

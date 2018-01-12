#
# Fibonacci
#

# Is there a way to hide this variable (class?)
call_count = 0

def fib_to(n):
    result = []
    a, b = 0, 1
    while b < n:
        result.append(b)
        a, b = b, a + b
    return result

def fibrec(n):
    if n <= 1:
        return 1
    return fibrec(n - 2) + fibrec(n - 1)

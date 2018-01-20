#
# Fibonacci
#

# Is there a way to hide this variable (class?)
call_count = 0

def fib_to(num: int) -> int:
    """Returns fibonacci numbers up to num"""
    result = []
    a, b = 0, 1
    while b < num:
        result.append(b)
        a, b = b, a + b
    return result

def fibrec(pos: int) -> int:
    """Returns the `num` position in the fibonacci sequence using recursion.

    Warning: This is crazy expensive. Do not call with num > 30
    """
    if pos <= 1:
        return 1
    return fibrec(pos - 2) + fibrec(pos - 1)

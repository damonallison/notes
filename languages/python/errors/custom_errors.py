"""A set of custom Errors used for understanding how except does error pattern matching"""


class MyError(Exception):
    """A custom error / exception"""
    pass

class DerivedError(MyError):
    """Derivation example"""
    pass

class FurtherDerivedError(DerivedError):
    """Further derivation example"""
    pass

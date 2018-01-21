"""Examples of exception handling"""

import unittest
from custom_errors import MyError, DerivedError, FurtherDerivedError

class ExceptionTests(unittest.TestCase):
    """A set of tests to illustrate exception handling."""
    @classmethod
    def setUpClass(cls) -> None:
        pass

    @classmethod
    def tearDownClass(cls) -> None:
        pass

    def setUp(self) -> None:
        pass

    def tearDown(self) -> None:
        pass

    def test_error(self) -> None:
        """Basic try / except syntax.
        
        Except clauses can handle multiple exceptions as a parenthesized tuple.
        """

        try:
            print(str( 10 / 0))
            self.fail(msg="Divide by zero should have caused the exception handler to trigger")
        except (ZeroDivisionError, TypeError, NameError):
            pass

    def test_hierarchy(self) -> None:

        execution_order = []
        for cls in [MyError,  DerivedError, FurtherDerivedError]:
            try:
                raise cls()
            except FurtherDerivedError:
                execution_order.append("FurtherDerivedError")
            except DerivedError:
                execution_order.append("DerivedError")
            except MyError:
                execution_order.append("MyError")
        

        


if __name__ == '__main__':
    unittest.main()

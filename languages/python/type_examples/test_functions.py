import unittest

class FunctionTests(unittest.TestCase):

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

    def fun_defaults(self, name: str, num: int=5) -> [str]:
        """Function arguments can have default values."""

        ret = []
        for i in range(0, num):
            ret.append(name)
        return ret

    def fun_keyword_args(self, *args: [str], **kwargs: {str : str}) -> ([str], {str : str}):
        """Functions can take arbitrary numbers of arguments and keyword arguments.

        Normally, *args is the last parameter. Anything after *args must be keyword arguments.
        """

        a = []
        for arg in args:
            a.append(arg)

        kw = {}
        for kwarg in kwargs:
            kw[kwarg] = kwargs[kwarg]

        return (a, kw)

    def test_defaults(self) -> None:
        """Tests functions with default parameters."""

        self.assertEqual(["damon", "damon"], self.fun_defaults("damon", num=2))
        self.assertEqual(["damon", "damon", "damon", "damon", "damon"], self.fun_defaults("damon"))

    def test_args(self) -> None:
        """Tests functions with variable arguments and variable keyword arguments."""

        (args, kwargs) = self.fun_keyword_args(1, 2, 3, first="damon", last="allison")

        self.assertEqual([1, 2, 3], args)

        self.assertEqual(
            kwargs,
            {"first" : "damon", "last" : "allison"})

        self.assertEqual(
            kwargs,
            {"last" : "allison", "first" : "damon"},
            msg="Dictionary ordering doesn't matter for equality checks")

    def test_unpacking_tuple(self) -> None:
        """Lists and dictionaries can be unpacked and sent into a function as parameters."""
        args = [1, 2, 3]
        kws = {"first" : "damon", "last" : "allison"}

        # Unpacks args using * and ** and send to `fun_keyword_args`
        (a, kw) = self.fun_keyword_args(*args, **kws)
        self.assertEqual(args, a)
        self.assertEqual(kws, kw)

    def test_lambdas(self) -> None:
        """Python lambdas are restricted to a single statement. They are syntactic sugar for a function definition."""

        def inner_func(val: str) -> str:
            """Example of an inner function"""
            return "echo " + val

        self.assertEqual("echo damon", inner_func("damon"))
        self.assertEqual("echo damon", (lambda x: "echo " + str(x))("damon"))

if __name__ == '__main__':
    unittest.main()

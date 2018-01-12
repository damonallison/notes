import unittest

class FunctionTests(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        pass

    @classmethod
    def tearDownClass(cls):
        pass

    def setUp(self):
        pass

    def tearDown(self):
        pass

    def fun_defaults(self, name, num=5):
        """Function definitions can have default values"""

        ret = []
        for i in range(0, num):
            ret.append(name)
        return ret

    def fun_keyword_args(self, *args, **kwargs):
        """Functions can take arbitrary numbers of arguments and keyword arguments"""

        a = []
        for arg in args:
            a.append(arg)

        kw = {}
        for kwarg in kwargs:
            kw[kwarg] = kwargs[kwarg]

        return (a, kw)

    def test_defaults(self):
        """Tests functions with default parameters"""

        self.assertEqual(["damon", "damon"], self.fun_defaults("damon", num=2))

    def test_args(self):
        """Tests functions with variable arguments and variable keyword arguments"""

        args, kwargs = self.fun_keyword_args(1, 2, 3, first="damon", last="allison")

        self.assertEqual([1, 2, 3], args)
        self.assertEqual(kwargs, {"first" : "damon", "last" : "allison"})
        self.assertEqual(
            kwargs,
            {"last" : "allison", "first" : "damon"},
            msg="Dictionary ordering doesn't matter"
        )

if __name__ == '__main__':
    unittest.main()

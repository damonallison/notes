import unittest

class ObjectTests(unittest.TestCase):

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

    def test_none(self):
        """There are two ways to check for `None`. Always use `is None`

        1. `obj is None`
        2. `obj == None`

        #2 `==` will use the class's implementation of `==` if it exists. Therefore, to always determine if a
        variable is truly `None`, use `is None`.
        """
        x = None
        self.assertTrue(x is None, msg="Always use `is None` to check for None");

    def test_sequences(self):
        """Strings are sequences and can be indexed."""

        s = "Damon"
        self.assertEqual(len(s), 5, msg="Use len() to determine sequence length")
        self.assertEqual(s[0:3].lower() + s[-1].lower(), "damn")


if __name__ == '__main__':
    unittest.main()

import unittest

class StringTests(unittest.TestCase):

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

    def test_sequences(self):
        """Strings are sequences and can be indexed."""

        s = "Damon"
        self.assertEqual(len(s), 5, msg="Use len() to determine sequence length")
        self.assertEqual(s[0:3].lower() + s[-1].lower(), "damn")


if __name__ == '__main__':
    unittest.main()

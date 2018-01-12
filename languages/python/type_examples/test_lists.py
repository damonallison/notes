import unittest

class ListTests(unittest.TestCase):

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

    def test_copy(self):
        """Lists are mutable. To copy, use [:]"""

        lst = ["damon", "kari"]
        copy = lst[:]
        self.assertFalse(lst is copy, msg="The objects are not referentially equivalent.")
        self.assertEqual(lst, copy, msg="The lists are logically equivalent")

    def test_append(self):
        """Lists are indexable and sliceable"""

        # Append will add a single value.
        lst = ["damon"]
        lst.append(42)

        # Adding lists together will concatentate the two lists.
        lst = lst + ["cole", 11]
        expected = ["damon", 42, "cole", 11]
        self.assertEqual(expected, lst)
        self.assertEqual(4, len(expected))

    def test_iteration(self):
        """`for` iterates over the elements in a sequence"""

        lst = ["damon", "kari", "grace", "lily", "cole"]
        expected = []

        for name in lst[:]: # iterate a copy of the list
            expected.append(name)
        self.assertEqual(expected, lst)

        # To iterate over the indices of a sequence, use range(len(lst))
        expected = []
        for i in range(len(lst)):
            expected.append(lst[i])
        self.assertEqual(expected, lst)

        # Loop statements can have an `else` clause, which executes
        # when the loop terminates without encoutering a `break` statement
        primes = []
        for n in range(2, 6):
            for x in range(2, n):
                if n % x == 0:
                    break
            else:
                primes.append(n)
        self.assertEqual([2, 3, 5], primes)


if __name__ == '__main__':
    unittest.main()

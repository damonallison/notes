import unittest

class ListTests(unittest.TestCase):
    """Tests for built in Python data structures : tuple, list, set, dictionary."""

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

    def test_copy(self) -> None:
        """Lists are mutable. To copy, use [:].

        Always use [:] for iteration.
        """

        lst = ["damon", "kari"]
        copy = lst[:]
        self.assertFalse(lst is copy, msg="The objects are not referentially equivalent.")
        self.assertEqual(lst, copy, msg="The lists are logically equivalent")

    def test_append(self):
        """Use .append(elt) and .extend(iterable) to append to a list."""

        # Append will add a single value.
        lst = ["damon"]
        lst.append(42)

        # + will concatentate the two lists (calling .extend(iterable) behind the scenes?)
        lst = lst + ["cole", 11]
        expected = ["damon", 42, "cole", 11]
        self.assertEqual(expected, lst)
        self.assertEqual(4, len(expected))

        # .extend(iterable) will append all items from iterable.
        # This is preferred over using `+` since it's clear what
        # you expect.
        expected = expected + ["grace", 13]
        lst.extend(["grace", 13])
        self.assertEqual(expected, lst)

    def test_iteration(self):
        """`for` iterates over the elements in a sequence."""

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

        # To iterate over indices and values simultaneously, use enumerate()
        pos = []
        val = []
        for i, v in enumerate(["tic", "tac", "toe"]):
            pos.append(i)
            val.append(v)

        self.assertEqual([0, 1, 2], pos)
        self.assertEqual(["tic", "tac", "toe"], val)

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


        # zip() allows you to loop multiple sequences simultaneously.
        # zip() will stop when any list is exhausted.
        questions = ["who", "what", "when", "where", "why"]
        answers = ["humperdink", "potion", "mideival", "sweden"]
        q2 = []
        a2 = []
        for q, a in zip(questions, answers):
            q2.append(q)
            a2.append(a)

        self.assertEqual(["who", "what", "when", "where"], q2)
        self.assertEqual(answers, a2)

    def test_list_comprehensions(self):
        """List comprehensions are a concise way to create lists."""

        squares = [x**2 for x in range(1, 4)]
        self.assertEqual([1, 4, 9], squares)

        evens = [x for x in range(1, 11) if x % 2 == 0]
        self.assertEqual([2, 4, 6, 8, 10], evens)

        squares = [(x, x **2) for x in [0, 1, 2, 3]]

        for x in range(len(squares)):
            self.assertEqual(squares[x][0], x)
            self.assertEqual(squares[x][1], x**2)

    def test_tuples(self):
        """Tuples are immutable sequences.

        In general, lists typically contain homogeneous elements.
        Tuples contain heterogeneous elements.

        Single element tuples must be defined with a trailing comma.
        t = 1,
        """

        t = (1, 2, 3)
        self.assertEqual((1, 2, 3), t)

        # You need the comment after the element for a single element tuple.
        t1 = 1,
        self.assertEqual((1,), t1)

        # Access tuple elements using list notation. t[pos]
        for x in range(0, len(t)):
            self.assertEqual(x, t[x] - 1)

    def test_sets(self):
        """Sets are created using set() or {e1, e2, ...}."""

        colors = {"orange", "yellow", "green"}

        self.assertTrue("orange" in colors)

        # Set comprehension is also supported
        filtered = {x for x in colors if len(x) > 5}

        self.assertEqual({"yellow", "orange"}, filtered)

    def test_dictionaries(self):
        """Dictionaries are key:value pairs.

        Dictionary keys can be any immutable type.
        Strings, numbers, or tuples can all be keys.
        """

        d = {"first" : "damon", "last" : "allison"}
        self.assertTrue("first" in d, msg="Test for membership.")

        del d["first"]
        self.assertFalse("first" in d)

        # Iterate dictionaries using key, value
        keys = set() #
        vals = set()
        for k, v in d.items():
            keys.add(k)
            vals.add(v)

        self.assertEqual({"last"}, keys)
        self.assertEqual({"allison"}, vals)


if __name__ == '__main__':
    unittest.main()

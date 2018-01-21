import unittest
import os.path

class IOTests(unittest.TestCase):
    """Tests for Python I/O."""

    testFileName = "test.txt"

    @classmethod
    def setUpClass(cls) -> None:
        pass

    @classmethod
    def tearDownClass(cls) -> None:
        pass

    def setUp(self) -> None:
        if os.path.exists(self.testFileName):
            os.remove(self.testFileName)

    def tearDown(self) -> None:
        # Ensure any resources created by this test suite are deleted.
        if os.path.exists(self.testFileName):
            os.remove(self.testFileName)

    def test_basic_printing(self) -> None:
        """str() == human readable output. repr() == interpreter readable output"""

        fname = "damon"
        lname = "allison"

        self.assertTrue(str(fname) == "damon")
        self.assertTrue(repr(fname) == "'damon'")

        # format using positional arguments
        self.assertEqual("damon allison", "{0} {1}".format(fname, lname))

        # format using keyword arguments
        self.assertEqual("damon allison", "{first} {last}".format(first=fname, last=lname))

    def test_reading_writing_files(self) -> None:
        """With will automatically close the file"""

        # Adding the newlines is extremely lame.
        lines = ["Hello\n", "World\n"]

        with open(self.testFileName, mode="w") as f:
            f.writelines(lines)

        with open(self.testFileName, mode="r") as f:
            read_lines = f.readlines()

        self.assertEqual(lines, [x for x in read_lines])


if __name__ == '__main__':
    unittest.main()

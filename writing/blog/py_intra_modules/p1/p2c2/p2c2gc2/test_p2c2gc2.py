import unittest

from ..m2 import M2
from ...p1c1.p1c2m1 import P1C1M1
from ....p2.p2m2 import P2M2
class P2C2GC2Test(unittest.TestCase):

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

    def test_module_imports(self) -> None:

        # Root Package 1

        self.assertTrue(isinstance(M1(), M1))
        self.assertTrue(isinstance(M2(), M2))
        self.assertTrue(isinstance(P1C1M1(), P1C1M1))

        # Root Package 2
        self.assertTrue(isinstance(P2M2(), P2M2))


if __name__ == '__main__':
    unittest.main()

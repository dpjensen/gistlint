"""
Test object.
"""

class TestClass(object):
    """docstring for TestClass."""
    def __init__(self, arg):
        self.cat = arg

    def print_cat(self):
        print("The best cat is a", self.cat)


def main():
    tgr = TestClass("Tiger")
    tgr.print_cat()


if __name__ == '__main__':
    main()

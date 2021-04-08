import unittest
from unittest.mock import patch
from helpers import perform_check


@patch("requests.get")
class Test(unittest.TestCase):
    def setUp(self):
        self.url = "https://www.example.com"

    def test_check(self, mock):
        with mock:
            check = perform_check(self.url)
            self.assertTrue(
                check.keys()
                >= {"created_at", "elapsed_time", "status_code", "url", "content_match"}
            )
            mock.assert_called_once_with(self.url)


if __name__ == "__main__":
    unittest.main()

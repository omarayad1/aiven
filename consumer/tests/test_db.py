import unittest
from unittest.mock import patch
from db import DB
from datetime import datetime


@patch("psycopg2.connect")
class Test(unittest.TestCase):
    def setUp(self):
        self.url = "postgres://localhost:5432"

    def test_mock(self, mock):
        with mock:
            db = DB(self.url)
            mock.assert_called_once_with(self.url)

    def test_create_hb_table(self, mock):
        with mock:
            db = DB(self.url)
            expected_query = """
        CREATE TABLE IF NOT EXISTS heartbeats (
            id serial PRIMARY KEY,
            url VARCHAR(255) NOT NULL,
            status_code INTEGER NOT NULL,
            elapsed_time FLOAT NOT NULL,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            content_match BOOLEAN
        );
        """
            db.create_hb_table()
            db._cursor.execute.assert_called_once_with(expected_query)
            db._conn.commit.assert_called_once_with()

    def test_insert_hb(self, mock):
        with mock:
            db = DB(self.url)
            expected_query = """
        INSERT INTO heartbeats (url, status_code, elapsed_time, created_at, content_match)
        VALUES(%s, %s, %s, %s, %s);
        """
            url, status_code, elapsed_time, created_at, content_match = (
                "https://www.example.com",
                200,
                0.5,
                datetime.now().isoformat(),
                True,
            )
            db.insert_hb(url, status_code, elapsed_time, created_at, content_match)
            db._cursor.execute.assert_called_once_with(
                expected_query,
                (url, status_code, elapsed_time, created_at, content_match),
            )
            db._conn.commit.assert_called_once_with()

    def test_close(self, mock):
        with mock:
            db = DB(self.url)
            db.close()
            db._conn.commit.assert_called_once_with()
            db._cursor.close.assert_called_once_with()
            db._conn.close.assert_called_once_with()


if __name__ == "__main__":
    unittest.main()

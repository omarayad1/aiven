import psycopg2


class DB(object):
    def __init__(self, url):
        self._conn = psycopg2.connect(url)
        self._cursor = self._conn.cursor()

    def create_hb_table(self):
        query = """
        CREATE TABLE IF NOT EXISTS heartbeats (
            id serial PRIMARY KEY,
            url VARCHAR(255) NOT NULL,
            status_code INTEGER NOT NULL,
            elapsed_time FLOAT NOT NULL,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
            content_match BOOLEAN
        );
        """
        self._cursor.execute(query)
        self._conn.commit()

    def insert_hb(self, url, status_code, elapsed_time, created_at, content_match):
        query = """
        INSERT INTO heartbeats (url, status_code, elapsed_time, created_at, content_match)
        VALUES(%s, %s, %s, %s, %s);
        """
        self._cursor.execute(
            query, (url, status_code, elapsed_time, created_at, content_match)
        )
        self._conn.commit()

    def close(self):
        self._conn.commit()
        self._cursor.close()
        if self._conn is not None:
            self._conn.close()

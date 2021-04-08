import re
import requests
from datetime import datetime


def is_valid_re(pattern):
    try:
        re.compile(pattern)
    except re.error:
        return False
    return True


def perform_check(url, re_pattern=None):
    request_datetime = datetime.now().isoformat()
    response = requests.get(url)
    content_match = None
    if re_pattern and response.status_code == 200:
        pattern = re.compile(re_pattern)
        content_match = bool(pattern.search(response.text))
    return {
        "status_code": response.status_code,
        "elapsed_time": response.elapsed.total_seconds(),
        "content_match": content_match,
        "url": response.url,
        "created_at": request_datetime,
    }

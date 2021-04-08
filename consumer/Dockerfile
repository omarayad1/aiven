FROM python:3.7-alpine

RUN mkdir -p /app

WORKDIR /app

RUN apk add --no-cache postgresql-libs
RUN apk add --virtual .build-deps gcc python3-dev musl-dev postgresql-dev

COPY requirements.txt /app

RUN pip install -r requirements.txt

RUN apk --purge del .build-deps

COPY . /app

CMD ["python", "-u", "main.py"]

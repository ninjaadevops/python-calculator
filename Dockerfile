FROM python:alpine

WORKDIR /app

COPY . /app
RUN pip install -r requirements.txt

EXPOSE 8000
EXPOSE 5000

CMD ["python3", "app.py"]

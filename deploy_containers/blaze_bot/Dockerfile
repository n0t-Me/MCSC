FROM zenika/alpine-chrome:with-chromedriver

USER root
RUN apk add --no-cache python3
RUN apk add --no-cache py3-pip

RUN pip install selenium --break-system-packages

USER chrome
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY . .
ENTRYPOINT ["python", "bot.py"]

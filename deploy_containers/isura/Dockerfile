FROM alpine/socat

WORKDIR /app

ENV PYTHONUNBUFFERED=1

RUN apk add --no-cache python3 py3-pycryptodome

COPY . .

ENTRYPOINT ["socat"]

CMD ["-dd","TCP-LISTEN:5000,reuseaddr,fork", "EXEC:'python ./server.py',pty,stderr,echo=0"]

FROM alpine/socat

WORKDIR /app

COPY . .

ENTRYPOINT ["socat"]

CMD ["-dd","TCP-LISTEN:5000,reuseaddr,fork", "EXEC:'./chall',pty,stderr,echo=0"]

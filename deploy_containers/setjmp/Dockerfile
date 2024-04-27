FROM ubuntu:22.04

RUN apt-get update

RUN apt-get install -y socat

WORKDIR /app

RUN useradd -ms /bin/sh challenge

COPY . .

RUN chmod +x chall

RUN chmod 444 flag.txt

USER challenge

ENTRYPOINT ["socat"]

CMD ["-dd","TCP-LISTEN:5000,reuseaddr,fork", "EXEC:'./chall',pty,stderr,echo=0,raw"]

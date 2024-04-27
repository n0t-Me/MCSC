FROM ctfd/ctfd:latest

WORKDIR /

WORKDIR /opt/CTFd/

COPY . CTFd/plugins/

RUN pip install -r CTFd/plugins/*/requirements.txt

ENTRYPOINT /opt/CTFd/docker-entrypoint.sh

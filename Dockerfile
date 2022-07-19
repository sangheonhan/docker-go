FROM sangheon/sandbox:22.04

WORKDIR /app/

RUN sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list && \
apt update -y && apt install -y gcc && \
wget -q https://go.dev/dl/go1.18.3.linux-amd64.tar.gz && \
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.3.linux-amd64.tar.gz && \
rm -f go1.18.3.linux-amd64.tar.gz && \
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.extra; \
apt clean autoclean -y && \
apt autoremove -y && \ 
rm -rf /var/lib/apt/lists /var/lib/apt/ /var/lib/cache/ /var/lib/log/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
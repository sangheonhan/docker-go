FROM sangheon/sandbox:20.04

RUN apt update -y && apt install -y gcc && \
wget -q https://go.dev/dl/go1.18.linux-amd64.tar.gz && \
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.18.linux-amd64.tar.gz && \
rm -f go1.18.linux-amd64.tar.gz && \
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.extra; \
apt clean autoclean -y && \
apt autoremove -y && \ 
rm -rf /var/lib/{apt,dpkg,cache,log}/

CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"

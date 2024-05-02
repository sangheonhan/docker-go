FROM sangheon/sandbox:24.04

ARG TARGETOS
ARG TARGETARCH

RUN sudo bash -c "apt update -y && apt install -y gcc && \
wget -q https://go.dev/dl/go1.22.0.$TARGETOS-$TARGETARCH.tar.gz && \
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.0.$TARGETOS-$TARGETARCH.tar.gz && \
rm -f go1.22.0.$TARGETOS-$TARGETARCH.tar.gz && \
chown -R app:app /app && \
apt clean autoclean -y && \
apt autoremove -y && \ 
rm -rf /var/lib/apt/lists /var/lib/apt/ /var/lib/cache/ /var/lib/log/" && \
echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.extra;

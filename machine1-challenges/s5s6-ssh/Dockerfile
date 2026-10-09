FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openssh-server \
    less \
    zip \
    unzip \
    e2fsprogs \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY files/ /setup/
COPY setup.sh /setup.sh
RUN sed -i 's/\r//' /setup.sh && chmod +x /setup.sh && bash /setup.sh

RUN mkdir -p /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN echo "AllowUsers deploy" >> /etc/ssh/sshd_config

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
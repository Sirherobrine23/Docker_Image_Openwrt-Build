FROM ubuntu:latest
LABEL maintainer="srherobrine20@gmail.com"
LABEL description="Openwrt AutoBuild para docker e CI/CD (Depende se dão suporte a imagens docker)"
RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt install -y curl sudo && \
    DEBIAN_FRONTEND=noninteractive apt -y install dos2unix git rsync mkisofs $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004) && \
    apt-get -qq autoremove --purge
RUN groupadd -g 999 copilador && useradd -r -u 999 -g copilador copilador && usermod -aG sudo copilador
RUN echo "copilador    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir /home/copiler/ && chmod 777 /home/copiler/
ADD start_new.sh /home/copiler/start.sh
RUN chmod a+x /home/copiler/start.sh && chmod 775 /home/copiler/start.sh
ADD start_new.sh /usr/sbin/start_new
RUN chmod a+x /usr/sbin/start_new && chmod 775 /usr/sbin/start_new
USER root

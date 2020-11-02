FROM ubuntu:latest
LABEL maintainer="srherobrine20@gmail.com"
LABEL description="Openwrt AutoBuild para docker e CI/CD (Depende se dão suporte a imagens docker)"
RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt install -y curl sudo && \
    DEBIAN_FRONTEND=noninteractive apt -y install dos2unix git rsync mkisofs $(curl -fsSL https://raw.githubusercontent.com/P3TERX/openwrt-list/master/depends-ubuntu-2004) && \
    apt-get -qq autoremove --purge
RUN groupadd -g 999 copilador && useradd -r -u 999 -g copilador copilador && usermod -aG sudo copilador
RUN echo "copilador    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir /home/copiler/ && chmod 777 /home/copiler/
RUN mkdir /__w/ && chown copilador:copilador /__w/ && chmod 777 /__w/
ADD 1.sh /home/copiler/1.sh
ADD 2.sh /home/copiler/2.sh
ADD 3.sh /home/copiler/3.sh
ADD 4.sh /home/copiler/4.sh
ADD 5.sh /home/copiler/5.sh
ADD 6.sh /home/copiler/6.sh
ADD 7.sh /home/copiler/7.sh
ADD 8.sh /home/copiler/8.sh
ADD 9.sh /home/copiler/9.sh
ADD start.sh /home/copiler/start.sh
ADD start_new.sh /usr/sbin/start_new
RUN chmod a+x /usr/sbin/start_new && \
    chmod 775 /usr/sbin/start_new
RUN dos2unix /home/copiler/*.sh
USER copilador

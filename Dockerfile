FROM openjdk:8

LABEL "com.synametrics.vendor"="Synametrics Technologies, Inc."
LABEL description="Xeams - A full SMTP Server with Spam Filtering"

MAINTAINER Synametrics <support@synametrics.com>

# Set correct environment variables
ENV SYN_DATA_DIR="/data/XeamsData" DEBIAN_FRONTEND=noninteractive HOME="/root" TERM=xterm

# set ports
EXPOSE 25 26 80 110 143 443 465 587 993 995 2525 5272 5273


# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add required files that are local
ADD srcxeams/ /root

# Fix a Debianism of the nobody's uid being 65534
RUN usermod -u 99 nobody && \
usermod -g 100 nobody && \
mv /root/startup-files/firstrun.sh /etc/init.d/firstrun.sh && \
chmod +x /etc/init.d/firstrun.sh && \
apt-get update && \
apt-get install -y vim && \
mkdir -p /root/temp && \
cd /root/temp && \
wget http://www.xeams.com/files/XeamsJava.tar && \
tar -xf XeamsJava.tar && \
gunzip -c Xeams.tar.gz | tar -xvf - && \
rm Xeams/config/AppConfig.xml && \
rm XeamsJava.tar && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
/usr/share/man /usr/share/groff /usr/share/info \
/usr/share/lintian /usr/share/linda /var/cache/man && \
(( find /usr/share/doc -depth -type f ! -name copyright|xargs rm || true )) && \
(( find /usr/share/doc -empty|xargs rmdir || true ))

COPY AppConfig.xml /opt/Xeams/config/

CMD /etc/init.d/firstrun.sh && /bin/bash

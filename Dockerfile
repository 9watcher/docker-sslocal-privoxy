FROM alpine:latest
MAINTAINER Ryan_Newman <15244909057.ww@gmail.com>

# use china souce
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

# set enviroment
ENV SS_SERVER=192.168.0.12
ENV SS_SERVER_PORT=443
ENV SS_SERVER_PASSWD=123456
ENV ENCRYPT_METHOD=aes-256-cfb
ENV SS_LOCAL_PORT=1080

# update software

RUN apk update
RUN apk upgrade
#install sslocal

RUN apk add py2-pip
RUN pip install shadowsocks
RUN apk add privoxy

# solve AttributeError: /usr/local/ssl/lib/libcrypto.so.1.1: undefined symbol: EVP_CIPHER_CTX_cleanup 
RUN sed -i '1,$s/CIPHER_CTX_cleanup/CIPHER_CTX_reset/g' /usr/lib/python2.7/site-packages/shadowsocks/crypto/openssl.py

# copy configure file
ADD ./sslocal/sslocal.sh /sslocal.sh
ADD ./privoxy/config /etc/privoxy/config

# run container

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN chmod +x /sslocal.sh

EXPOSE 1080 8118

CMD ["/entrypoint.sh"]

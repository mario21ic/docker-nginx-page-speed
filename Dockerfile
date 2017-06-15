FROM amazonlinux:latest
MAINTAINER Mario Inga <mario21ic@gmail.com>

RUN yum install -y curl telnet\
    wget gcc-c++ pcre-devel pcre-devel zlib-devel make unzip openssl-devel 
#&&\ #mkdir /etc/nginx/websites/

# Config Nginx
COPY ./nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /opt/nginx/modules
RUN cd /opt/nginx/modules && wget https://github.com/pagespeed/ngx_pagespeed/archive/release-1.7.30.3-beta.zip && unzip release-1.7.30.3-beta.zip
RUN cd /opt/nginx/modules/ngx_pagespeed-release-1.7.30.3-beta/ && wget https://dl.google.com/dl/page-speed/psol/1.7.30.3.tar.gz && tar -xzf 1.7.30.3.tar.gz

RUN cd /opt/nginx/ && wget http://nginx.org/download/nginx-1.4.5.tar.gz && tar -zxf nginx-1.4.5.tar.gz
RUN cd /opt/nginx/nginx-1.4.5/ && ./configure --add-module=/opt/nginx/modules/ngx_pagespeed-release-1.7.30.3-beta \
--prefix=/usr/local/nginx \
--sbin-path=/usr/local/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/run/nginx.pid \
--lock-path=/run/lock/subsys/nginx \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_gzip_static_module \
--without-mail_pop3_module \
--without-mail_imap_module \
--without-mail_smtp_module \
--user=nginx \
--group=nginx && make && make install

EXPOSE 80

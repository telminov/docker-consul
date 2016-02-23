# docker build -t telminov/consul .

FROM ubuntu:14.04
MAINTAINER telminov@soft-way.biz

EXPOSE 53/udp 8300 8301 8301/udp 8302 8302/udp 8400 8500

VOLUME /data
VOLUME /webui
VOLUME /config

RUN apt-get -qqy update && apt-get install unzip curl -qqy

# download
ADD https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip /tmp/consul.zip
ADD https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_web_ui.zip /tmp/consul_ui.zip

# unzip consul to /opt/consul/consul
RUN cd /usr/sbin && unzip /tmp/consul.zip && chmod +x consul && rm /tmp/consul.zip

# unzip webui to /opt/consul/webui/
RUN cd /webui && unzip /tmp/consul_ui.zip && rm /tmp/consul_ui.zip

RUN mkdir /etc/consul/
ADD consul.json /etc/consul/consul.sample.json

CMD test "$(ls /config/consul.json)" || cp /etc/consul/consul.sample.json /config/consul.json; \
    /usr/sbin/consul agent -config-dir=/config/

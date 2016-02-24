# docker build -t telminov/consul .

FROM ubuntu:14.04
MAINTAINER telminov@soft-way.biz

EXPOSE 53/udp 8300 8301 8301/udp 8302 8302/udp 8400 8500

VOLUME /data
VOLUME /config

RUN apt-get -qqy update && apt-get install unzip curl -qqy

# download
ADD https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_linux_amd64.zip /tmp/consul.zip
ADD https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_web_ui.zip /tmp/consul_ui.zip

RUN mkdir /opt/consul
RUN mkdir /opt/consul/webui
RUN mkdir /opt/consul/config

# unzip consul to /opt/consul/consul
RUN cd /opt/consul && unzip /tmp/consul.zip && chmod +x consul && rm /tmp/consul.zip
RUN ln -s /opt/consul/consul /usr/sbin/consul

# unzip webui to /opt/consul/webui/
RUN cd /opt/consul/webui && unzip /tmp/consul_ui.zip && rm /tmp/consul_ui.zip

# default config
ADD config/consul.json /opt/consul/config/consul.sample.json

CMD test "$(ls /config/consul.json)" || cp /opt/consul/config/consul.sample.json /config/consul.json; \
    /usr/sbin/consul agent -config-dir=/config/

FROM alpine:latest

ARG TINYPROXY_PORT=8888

# The base image is Alpine Linux
RUN apk add --no-cache tinyproxy jq curl

RUN mkdir /scripts
COPY tinyproxy_configure.sh /scripts/tinyproxy_configure.sh
COPY run /scripts/run
RUN chmod 755 /scripts/tinyproxy_configure.sh /scripts/run

# The text that follows 'TINYPROXY_' needs to match the name of the configuration item found within the tinyproxy.conf file
# For configuration items that can be repeated (e.g. 'Allow'), the value should be a comma-separated list to be expanded by tinyproxy_configure.sh
ENV TINYPROXY_User=nobody
ENV TINYPROXY_Group=nobody
ENV TINYPROXY_Port=${TINYPROXY_PORT}
# Skipping 'TINYPROXY_Listen' -- 'Listen' is configured automatically by tinyproxy_configure.sh since the value isn't known until runtime
# Skipping 'TINYPROXY_Bind' -- 'Bind' is configured automatically by tinyproxy_configure.sh since the value isn't known until runtime
ENV TINYPROXY_Timeout=600
ENV TINYPROXY_DefaultErrorFile='"/usr/share/tinyproxy/default.html"'
ENV TINYPROXY_StatFile='"/usr/share/tinyproxy/stats.html"'
ENV TINYPROXY_XTinyproxy=No
ENV TINYPROXY_LogLevel=Info
ENV TINYPROXY_MaxClients=100
# Skipping 'TINYPROXY_Allow' -- When omitted, Tinyproxy listens on all IPs. If you set this, the 'Listen' IP will be injected by tinyproxy_configure.sh
ENV TINYPROXY_ViaProxyName='"tinyproxy"'
ENV TINYPROXY_DisableViaHeader=Yes

EXPOSE ${TINYPROXY_PORT}

CMD ["/scripts/run"]

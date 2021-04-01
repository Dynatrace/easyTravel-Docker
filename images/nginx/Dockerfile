FROM nginx:1.9.11

LABEL maintainer="Rafal Psciuk <rafal.psciuk@dynatrace.com>, Tomasz Wieremjewicz <tomasz.wieremjewicz@dynatrace.com>"

# Deploy 'nginx.conf' file
COPY conf/nginx.conf /etc/nginx/nginx.conf

ENV  ET_RUNTIME_DEPS "curl netcat openssl"
RUN  apt-get update && \
     apt-get install -y ${ET_RUNTIME_DEPS} && \
     rm -rf /var/lib/apt/lists/* /tmp/*

COPY build/scripts/wait-for-cmd.sh /usr/local/bin
COPY build/scripts/run-process.sh /

EXPOSE 80
EXPOSE 8080
EXPOSE 9079

CMD /run-process.sh

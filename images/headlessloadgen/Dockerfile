FROM debian:buster

LABEL maintainer="Rafal Psciuk <rafal.psciuk@dynatrace.com>, Tomasz Wieremjewicz <tomasz.wieremjewicz@dynatrace.com>"

ENV ET_RUNTIME_DEPS "default-jre netcat wget default-jre netcat wget libasound2 libatk-bridge2.0-0 libatk1.0-0 libc6:amd64 libcairo2 libcups2 libgdk-pixbuf2.0-0 libgtk-3-0 libnspr4 libnss3 libxss1 libxslt1.1 xdg-utils libminizip-dev libgbm-dev libflac8"
RUN  apt-get update && \
     apt-get install -y --no-install-recommends ${ET_RUNTIME_DEPS} && \
     rm -rf /var/lib/apt/lists/* /tmp/*

ENV ET_HOME /easytravel
ADD build/headlessloadgen.tar.gz ${ET_HOME}
RUN mv ${ET_HOME}/chrome-lin64 ${ET_HOME}/chrome

COPY build/scripts/run-problem-patterns.sh /usr/local/bin
COPY build/scripts/wait-for-cmd.sh /usr/local/bin
COPY build/scripts/run-process.sh /

WORKDIR ${ET_HOME}

ENTRYPOINT /run-process.sh

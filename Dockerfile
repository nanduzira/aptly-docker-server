FROM debian:latest

LABEL maintainer="me@nanduzira.dev"

ARG DEBIAN_FRONTEND=noninteractive

# update apt repository and install necessary packages
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y  \
  bzip2 gnupg2 gpgv graphviz supervisor nginx curl xz-utils apt-utils gettext-base bash-completion

RUN curl -sL https://www.aptly.info/pubkey.txt | gpg --dearmor | tee /etc/apt/trusted.gpg.d/aptly.gpg >/dev/null
RUN mkdir -p /etc/apt/sources.list.d && \
    echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list

# install aptly package
RUN apt-get update -q && apt-get install -y aptly && apt-get clean && rm -rf /var/lib/apt/lists/*

# create volume
VOLUME [ "/opt/aptly" ]
ENV GNUPGHOME="/opt/aptly/gpg"

# add configurations
COPY rootfs /

# configure bash completions
ADD https://raw.githubusercontent.com/aptly-dev/aptly/master/completion.d/aptly /usr/share/bash-completion/completions/aptly
RUN echo "if ! shopt -oq posix; then\n\
  if [ -f /usr/share/bash-completion/bash_completion ]; then\n\
    . /usr/share/bash-completion/bash_completion\n\
  elif [ -f /etc/bash_completion ]; then\n\
    . /etc/bash_completion\n\
  fi\n\
fi" >> /etc/bash.bashrc

# declare ports in use
EXPOSE 8080

# start supervisor when container starts
CMD /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

WORKDIR /opt/aptly

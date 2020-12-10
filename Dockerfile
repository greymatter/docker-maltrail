ROM alpine:3.7

LABEL maintainer="Todd Smetanka <s4biturbo@gmail.com>"

# Install packages and python dependencies
# Install dev dependencies
# Download source code and install it
# Cleanup directories
# hadolint ignore=DL3018
RUN apk -U upgrade && apk --no-cache add \
    curl \
    bash \
    python \
    libstdc++ \
    libpcap \
 && apk --update add --virtual build-dependencies \
    git \
    build-base \
    py-pip \
    libpcap-dev \
    python-dev \
 && pip install --disable-pip-version-check pcapy==0.11.3 \
 && git clone https://github.com/stamparm/maltrail.git /opt/maltrail \
 && apk del build-dependencies \
 && rm -fr /root/.cache

RUN  cd /opt/maltrail/trails/feeds \
  && curl https://raw.githubusercontent.com/carlospolop/MaltrailWorld/master/trails/feeds/malwareworld_domains.py --output malwareworld_domains.py \
  && curl https://raw.githubusercontent.com/carlospolop/MaltrailWorld/master/trails/feeds/malwareworld_ips.py --output malwareworld_ips.py \
   && python /opt/maltrail/core/update.py

WORKDIR /opt/maltrail

RUN cd /opt/maltrail \
   && pip install -r requirements.txt

EXPOSE 8338

ENTRYPOINT  ["python", "/root/server.py"]

WORKDIR /opt/maltrail/

# Start maltrail server
CMD [ "python", "./server.py" ]

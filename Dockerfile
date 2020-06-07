FROM ubuntu:latest

LABEL Sahaj Quinci

ENV DEBIAN_FRONTEND noninteractive

RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty multiverse" > /etc/apt/sources.list.d/multiverse.list

# RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections \
#         && apt-get update \
#         && apt-get install -y --no-install-recommends \
#         wget \
#         unzip \
#         libicu52 \
#         libjpeg8 \
#         libwebp5 \
#         libfreetype6 \
#         libfontconfig \
#         ttf-mscorefonts-installer \
#         && rm -rf /var/lib/apt/lists/*

# RUN wget -q --no-check-certificate -O /tmp/phantomjs-2.0.0-20150528-u1404-x86_64.zip https://github.com/bprodoehl/phantomjs/releases/download/v2.0.0-20150528/phantomjs-2.0.0-20150528-u1404-x86_64.zip \
#         && unzip /tmp/phantomjs-2.0.0-20150528-u1404-x86_64.zip -d /tmp \
#         && ln -s /tmp/phantomjs-2.0.0-20150528/bin/phantomjs /usr/bin/phantomjs \
#         && rm /tmp/phantomjs-2.0.0-20150528-u1404-x86_64.zip

 RUN apt-get update && \
     apt-get install wget -y && \
     apt-get install build-essential chrpath libssl-dev libxft-dev -y && \
     apt-get install libfreetype6 libfreetype6-dev -y && \
     apt-get install libfontconfig1 libfontconfig1-dev -y && \
     export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64" && \
     wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/$PHANTOM_JS.tar.bz2 && \
     tar xvjf $PHANTOM_JS.tar.bz2 && \
     mv $PHANTOM_JS /usr/local/share && \
     ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin && phantomjs --version

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

COPY ./requirements.txt /app/requirements.txt

WORKDIR /app

RUN pip install -r requirements.txt

COPY . /app

ENTRYPOINT [ "python" ]

CMD [ "app.py" ]
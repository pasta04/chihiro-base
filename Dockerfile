FROM timbru31/ruby-node

# Create app directory
WORKDIR /usr/src/app

# Ruby
RUN gem update --system
RUN gem install crypt msgpack httpclient json mikunyan

RUN apt-get update

# VGMStream
RUN	apt-get -y install gcc g++ cmake make autoconf automake libtool git
RUN apt-get -y install libmpg123-dev libvorbis-dev libspeex-dev audacious-dev audacious libglib2.0-dev libgtk2.0-dev libpango1.0-dev libao-dev liblz4-tool sqlite3 perl pkg-config
RUN	pkg-config --modversion audacious
RUN	git clone --depth 1 https://github.com/losnoco/vgmstream ~/vgmstream &&\
	cd ~/vgmstream &&\
	mkdir -p build && cd build &&\
	cmake -DCMAKE_INSTALL_PREFIX=/usr ../ &&\
	make -j20 &&\
	make install

# Node-gyp
RUN apt-get -y install build-essential python2.7

# 日本語環境に
RUN apt-get install -y locales \
    && locale-gen ja_JP.UTF-8 \
    && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc

# タイムゾーン
RUN apt install -y tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*
ENV TZ Asia/Tokyo

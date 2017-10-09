FROM alpine:3.5
RUN apk add --update \
	build-base 
	
RUN  cd /tmp \
	&& wget http://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p320.tar.gz \
	&& tar -zxf ruby-1.9.2-p320.tar.gz 
	
RUN cd /tmp/ruby-1.9.2-p320 \
	&& ./configure -disable-install-doc \
	&& make \
	&& make install

RUN mkdir /QASite

COPY . /QASite


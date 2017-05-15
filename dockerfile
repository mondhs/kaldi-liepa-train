FROM ubuntu:16.04

Maintainer mondhs bus<mondhs@gmail.com>
#docker build -t liepa-train-kaldi .
#docker run -it liepa-train-kaldi bash

#COPY opt /opt

RUN curl -SL https://github.com/kaldi-asr/kaldi/archive/master.zip | tar -xz -C /opt/
RUN curl -SL https://github.com/mondhs/kaldi-liepa-train/archive/master.zip | tar -xz -C /opt/


RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade  && \
  apt-get install -y --no-install-recommends apt-utils && \
  apt-get install -y build-essential zlib1g-dev automake autoconf wget git libtool subversion python libatlas3-base



WORKDIR "/opt/kaldi/tools"
RUN make
WORKDIR "/opt/kaldi/src"
RUN  ./configure 
RUN make depend 
RUN make
RUN ln -s /opt/kaldi/egs/wsj/s5/steps/ steps
RUN ln -s /opt/kaldi/egs/wsj/s5/utils/ utils

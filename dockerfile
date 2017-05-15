FROM ubuntu:16.04

Maintainer mondhs bus<mondhs@gmail.com>
#docker build -t liepa-train-kaldi .
#docker run -v /c/Users/Naudotojas/liepa/LIEPA_garsynas:/data -it liepa-train-kaldi bash

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

RUN mkdir -p /opt/kaldi-liepa-train/liepa_audio
RUN ln -s /opt/kaldi/egs/wsj/s5/steps/ /opt/kaldi-liepa-train/steps
RUN ln -s /opt/kaldi/egs/wsj/s5/utils/ /opt/kaldi-liepa-train/utils
RUN ln -s /data/train_repo /opt/kaldi-liepa-train/liepa_audio/train
RUN ln -s /data/test_repo /opt/kaldi-liepa-train/liepa_audio/test

WORKDIR "/opt/kaldi/tools"
RUN ./install_srilm.sh


FROM ubuntu:16.04

Maintainer mondhs bus<mondhs@gmail.com>
##### Extend docker mashine to 50G
# docker machine -D create -d virtualbox --virtualbox-disk-size "50000" default
##### Build docker
#docker build -t liepa-train-kaldi .
##### Bash interface
#docker run  -v /c/Users/Naudotojas/liepa/LIEPA_garsynas:/data -it liepa-train-kaldi bash
#### Web wrapper
#docker run -p 8081:8081 -p 8082:8082 -v /c/Users/Naudotojas/liepa/LIEPA_garsynas:/data -it liepa-train-kaldi


# Thanks:
## https://github.com/keighrim/kaldi-yesno-tutorial
## https://github.com/sspreitzer/docker-shellinabox

COPY opt /opt


###################### INSTALL Kaldi ##############################


RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade  && \
  apt-get install -y --no-install-recommends apt-utils git ca-certificates curl sudo

# Kaldi toolkit
RUN git clone https://github.com/kaldi-asr/kaldi.git /opt/kaldi --depth 1

RUN apt-get install -y build-essential gawk zlib1g-dev automake autoconf wget libtool subversion python libatlas3-base


WORKDIR "/opt/kaldi/tools"
RUN make -j 2
WORKDIR "/opt/kaldi/src"
RUN  ./configure
RUN make -j 2 depend
RUN make -j 2

RUN mkdir -p /opt/kaldi-liepa-train/liepa_audio
RUN ln -s /opt/kaldi/egs/wsj/s5/steps/ /opt/kaldi-liepa-train/steps
RUN ln -s /opt/kaldi/egs/wsj/s5/utils/ /opt/kaldi-liepa-train/utils
RUN ln -s /data/train_repo /opt/kaldi-liepa-train/liepa_audio/train
RUN ln -s /data/test_repo /opt/kaldi-liepa-train/liepa_audio/test

WORKDIR "/opt/kaldi/tools"
# Please, do not use this link. You must download your self: http://www.speech.sri.com/projects/srilm/download.html
# COPY /data/srilm-1.7.2.tar.gz /opt/kaldi/tools/srilm.tgz
RUN curl  https://raw.githubusercontent.com/denizyuret/nlpcourse/master/download/srilm-1.7.0.tgz > /opt/kaldi/tools/srilm.tgz
RUN ./install_srilm.sh

############################### Web Wrapper ##########################################

#Web training wrapper
RUN git clone  https://github.com/mondhs/nodejs_kaldi_train_wrapper.git /opt/wrapper --depth 1
RUN rm -rf /opt/wrapper/contol_files
RUN ln -s /opt/kaldi-liepa-train /opt/wrapper/contol_files

RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
WORKDIR "/opt/wrapper"
RUN npm install ws --save
CMD ["npm", "start"]

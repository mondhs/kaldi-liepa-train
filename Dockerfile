FROM ubuntu:16.04

Maintainer mondhs bus<mondhs@gmail.com>
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

#RUN curl -SL https://github.com/kaldi-asr/kaldi/archive/master.zip | tar -xz -C /opt/
#RUN curl -SL https://github.com/mondhs/kaldi-liepa-train/archive/master.zip | tar -xz -C /opt/

###################### INSTALL Kaldi ##############################


RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade  && \
  apt-get install -y --no-install-recommends apt-utils git ca-certificates curl sudo

# Kaldi toolkit
RUN git clone https://github.com/kaldi-asr/kaldi.git /opt/kaldi --depth 1

RUN apt-get install -y build-essential zlib1g-dev automake autoconf wget libtool subversion python libatlas3-base


#WORKDIR "/opt/kaldi/tools"
#RUN make
#WORKDIR "/opt/kaldi/src"
#RUN  ./configure
#RUN make depend
#RUN make

#RUN mkdir -p /opt/kaldi-liepa-train/liepa_audio
#RUN ln -s /opt/kaldi/egs/wsj/s5/steps/ /opt/kaldi-liepa-train/steps
#RUN ln -s /opt/kaldi/egs/wsj/s5/utils/ /opt/kaldi-liepa-train/utils
#RUN ln -s /data/train_repo /opt/kaldi-liepa-train/liepa_audio/train
#RUN ln -s /data/test_repo /opt/kaldi-liepa-train/liepa_audio/test

#WORKDIR "/opt/kaldi/tools"
#RUN ./install_srilm.sh

############################### Web Wrapper ##########################################

#Web training wrapper
RUN git clone  https://github.com/mondhs/nodejs_kaldi_train_wrapper.git /opt/wrapper --depth 1

RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
WORKDIR "/opt/wrapper"
RUN npm install ws --save
CMD ["npm", "start"]

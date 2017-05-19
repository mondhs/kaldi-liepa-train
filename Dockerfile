FROM ubuntu:16.04

Maintainer mondhs bus<mondhs@gmail.com>
#docker build -t liepa-train-kaldi .
#docker run -v /c/Users/Naudotojas/liepa/LIEPA_garsynas:/data -it liepa-train-kaldi bash

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
  apt-get install -y --no-install-recommends apt-utils
  #&& \
#  apt-get install -y build-essential zlib1g-dev automake autoconf wget git libtool subversion python libatlas3-base


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

########################## INSTALL shellinabox ###################

ENV SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
  SIAB_PORT=4200 \
  SIAB_ADDUSER=true \
  SIAB_USER=guest \
  SIAB_USERID=1000 \
  SIAB_GROUP=guest \
  SIAB_GROUPID=1000 \
  SIAB_PASSWORD=liepa \
  SIAB_SHELL=/bin/bash \
  SIAB_HOME=/home/guest \
  SIAB_SUDO=false \
  SIAB_SSL=true \
  SIAB_SERVICE=/:LOGIN \
  SIAB_PKGS=none \
  SIAB_SCRIPT=none

RUN apt-get install -y openssl curl openssh-client sudo \
      shellinabox && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  ln -sf '/etc/shellinabox/options-enabled/00+Black on White.css' \
    /etc/shellinabox/options-enabled/00+Black-on-White.css && \
  ln -sf '/etc/shellinabox/options-enabled/00_White On Black.css' \
    /etc/shellinabox/options-enabled/00_White-On-Black.css && \
  ln -sf '/etc/shellinabox/options-enabled/01+Color Terminal.css' \
    /etc/shellinabox/options-enabled/01+Color-Terminal.css

EXPOSE 4200

VOLUME /etc/shellinabox /var/log/supervisor /home


ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["shellinabox"]

FROM ubuntu:12.04
MAINTAINER Yosuke Furukawa <yosuke.furukawa@gmail.com>

RUN apt-get -q update; apt-get -y upgrade
RUN apt-get -y install build-essential sudo curl wget git-core

# Create user
RUN useradd -u 45678 -s /bin/bash -m worker

# INSTALL nodebrew
WORKDIR /home/worker/
RUN sudo -uworker wget git.io/nodebrew -O /home/worker/nodebrew
RUN sudo -uworker NODEBREW_ROOT=/home/worker/.nodebrew perl /home/worker/nodebrew setup

# INSTALL node
RUN sudo -uworker NODEBREW_ROOT=/home/worker/.nodebrew /home/worker/.nodebrew/current/bin/nodebrew install-binary 0.8
RUN sudo -uworker NODEBREW_ROOT=/home/worker/.nodebrew /home/worker/.nodebrew/current/bin/nodebrew install-binary 0.9
RUN sudo -uworker NODEBREW_ROOT=/home/worker/.nodebrew /home/worker/.nodebrew/current/bin/nodebrew install-binary 0.10
RUN sudo -uworker NODEBREW_ROOT=/home/worker/.nodebrew /home/worker/.nodebrew/current/bin/nodebrew install-binary 0.11

# Make workspace
RUN mkdir /workspace

ENTRYPOINT ["/bin/bash", "-c"]

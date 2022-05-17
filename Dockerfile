# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y g++ bison flex make

ADD . /jaws
WORKDIR /jaws
RUN make 


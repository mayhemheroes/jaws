# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder
RUN printf "deb http://snapshot.ubuntu.com/ubuntu/20250501T000000Z/ focal main restricted universe multiverse\ndeb http://snapshot.ubuntu.com/ubuntu/20250501T000000Z/ focal-updates main restricted universe multiverse\ndeb http://snapshot.ubuntu.com/ubuntu/20250501T000000Z/ focal-security main restricted universe multiverse\n" > /etc/apt/sources.list && apt-get -o Acquire::https::Verify-Peer=false update -o Acquire::Check-Valid-Until=false
RUN DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::https::Verify-Peer=false install -y g++ bison flex make wget unzip

ADD . /jaws
WORKDIR /jaws
RUN make 

RUN mkdir -p /deps
RUN ldd /jaws/finCompiler/finc | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /jaws/finCompiler/finc /jaws/finCompiler/finc
ENV LD_LIBRARY_PATH=/deps


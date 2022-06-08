# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y g++ bison flex make

ADD . /jaws
WORKDIR /jaws
RUN make 

RUN mkdir -p /deps
RUN ldd /jaws/finCompiler/finc | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /jaws/finCompiler/finc /jaws/finCompiler/finc
ENV LD_LIBRARY_PATH=/deps


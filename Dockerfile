FROM ubuntu:20.04

LABEL name=Manticore
LABEL src="https://github.com/trailofbits/manticore"
LABEL creator="Trail of Bits"
LABEL dockerfile_maintenance=trailofbits

ENV LANG C.UTF-8

RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get -y install python3 python3-dev python3-pip git wget software-properties-common
RUN add-apt-repository ppa:sri-csl/formal-methods -y
RUN apt-get update
RUN apt-get install yices2 -y

# Install solc 0.4.25 and validate it
RUN wget https://github.com/ethereum/solidity/releases/download/v0.4.25/solc-static-linux \
 && chmod +x solc-static-linux \
 && mv solc-static-linux /usr/bin/solc

# If this fails, the solc-static-linux binary has changed while it should not.
RUN [ "c9b268750506b88fe71371100050e9dd1e7edcf8f69da34d1cd09557ecb24580  /usr/bin/solc" = "$(sha256sum /usr/bin/solc)" ]

RUN python3 -m pip install -U pip

ADD . /manticore
RUN cd manticore && pip install -e ".[dev-noks]"

CMD ["/bin/bash"]

FROM rust

RUN rustup component add clippy rustfmt

RUN apt-get update -y
RUN apt-get install -y automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf

ARG version=v3.1.5

RUN git clone --recurse-submodules https://github.com/AndrewWestberg/cncli
WORKDIR "cncli"
RUN git checkout $version
RUN cargo install --path . --force      
RUN cncli --version

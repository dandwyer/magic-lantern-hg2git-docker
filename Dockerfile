# syntax=docker/dockerfile:1
FROM ubuntu:24.04

RUN apt-get update \
    && apt-get install -y \
        git \
        mercurial \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src

# https://www.magiclantern.fm/downloads.html
RUN hg clone -u unified \
    https://foss.heptapod.net/magic-lantern/magic-lantern/ magic-lantern-hg

# https://github.com/frej/fast-export
RUN git clone https://github.com/frej/fast-export.git

COPY branch.map .
COPY cherry-pick-x ./cherry-pick-x

RUN git init magic-lantern

WORKDIR /src/magic-lantern

RUN ../fast-export/hg-fast-export.sh \
    -r ../magic-lantern-hg \
    --ignore-unnamed-heads \
    --plugin cherry-pick-x \
    --plugin-path .. \
    -B ../branch.map \
    -n

CMD ["echo" , "DONE!"]

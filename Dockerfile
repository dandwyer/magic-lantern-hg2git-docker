# syntax=docker/dockerfile:1
FROM ubuntu:24.04 AS hg2git

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
    --plugin cherry-pick-x=append-branch \
    --plugin-path .. \
    -B ../branch.map \
    -n

RUN git checkout unified

FROM hg2git AS finalized_repo

# Reduce the size of the .git directory from 320 MB to 40 MB
RUN git gc --aggressive --prune=all

RUN git remote add origin \
    https://github.com/dandwyer/magic-lantern.git

# Print the size of the .git directory to monitor efficiency
CMD ["du" , "-h", "-d", "1", ".git"]

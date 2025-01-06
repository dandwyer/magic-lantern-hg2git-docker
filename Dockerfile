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

# Capture all of the more recent development activity, but rebase it onto
# commits that reference Mercurial changesets.
FROM hg2git AS rebase_simplified

RUN apt-get update \
    && apt-get install -y \
    git-filter-repo \
    && rm -rf /var/lib/apt/lists/*

RUN git remote add simplified \
    https://github.com/reticulatedpines/magiclantern_simplified.git
RUN git fetch simplified dev
RUN git checkout -b main --track simplified/dev

# The `dev` branch connects to the commits in the original Mercurial repository via
# two merge commits. We navigate to these commits and swap from the parents without
# Mercurial changeset attribution to the parents with Mercurial changeset attribution.
RUN git merge-base --is-ancestor \
    b51cae028018f8754b107fc30a7adf5c1cbd8b9d \
    ee9a94ae583b23764c389e9245e8813d61485683
RUN git replace ee9a94ae583b23764c389e9245e8813d61485683 \
    $(git log --grep="1939f0c3d408f51d4827d9e5515f647e7a47a0b6" --all --format="%H")
RUN git replace b51cae028018f8754b107fc30a7adf5c1cbd8b9d \
    $(git log --grep="d78f841fa972274522b3c9ac287e397469b152e8" --all --format="%H")
RUN git filter-repo --force --replace-refs delete-no-add

FROM rebase_simplified AS finalized_repo

# Reduce the size of the .git directory from 301 MB to 43 MB
RUN git gc --aggressive --prune=all

RUN git remote add origin \
    https://github.com/dandwyer/magic-lantern.git

# Print the size of the .git directory to monitor efficiency
CMD ["du" , "-h", "-d", "1", ".git"]

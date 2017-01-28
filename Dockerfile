# see OS Baselines in Devops @ Kuali
FROM node:6-alpine

# Assertion: for this to work, the BASE_SRC needs to be
# checked into current folder under 'ops-batleth'
ARG BASE_SRC
ARG BASE_REPO
ARG BASE_DST

# safety net
RUN if [ ! $BASE_DST ]; then exit 1;\
    elif [ ! $BASE_SRC ]; then exit 1;\
    elif [ ! $BASE_REPO ]; then exit 1; fi

RUN [ ! -d $BASE_DST ] && mkdir -p $BASE_DST

# the order is important, as Docker will fall back to the lowest
# step in the chain.  Because of this, we start with package.json
WORKDIR $BASE_DST
COPY $BASE_SRC/package.json $BASE_DST
RUN npm install
COPY $BASE_SRC $BASE_DST
COPY $BASE_REPO/.pkg $BASE_DST/.pkg
COPY $BASE_REPO/config $BASE_DST/config

ARG BUILD_VERSION
RUN if [ ! $BUILD_VERSION ]; then exit 1; fi
RUN echo '{"build":{"version":"'$BUILD_VERSION'"}}' >> $BASE_DST/config/local.json

# do other things like babel here

EXPOSE 4000

ENTRYPOINT ["/app/ephemer/bin/launch", "service"]

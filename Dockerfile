# see OS Baselines in Devops @ Kuali
FROM node:6-alpine

# Assertion: for this to work, the BASE_SRC needs to be
# checked into current folder under 'ops-batleth'
# not working in Docker cloud automated builds
#ARG BASE_DST
#ARG BASE_SRC
#ARG BASE_REPO
ENV BASE_DST=/app/test-node
ENV BASE_REPO=./
ENV BASE_SRC=./app

# safety net
RUN if [ ! $BASE_DST ]; then exit 1; fi
RUN if [ ! $BASE_SRC ]; then exit 1; fi
RUN if [ ! $BASE_REPO ]; then exit 1; fi

RUN if [ ! -d $BASE_DST ]; then mkdir -p $BASE_DST; fi

# the order is important, as Docker will fall back to the lowest
# step in the chain.  Because of this, we start with package.json
WORKDIR $BASE_DST
COPY $BASE_SRC/package.json $BASE_DST
RUN npm install
COPY $BASE_SRC $BASE_DST
COPY $BASE_REPO/.pkg $BASE_DST/.pkg
COPY $BASE_REPO/config $BASE_DST/config

ENV BUILD_VERSION=10
RUN if [ ! $BUILD_VERSION ]; then exit 1; fi
RUN echo '{"build":{"version":"'$BUILD_VERSION'"}}' >> $BASE_DST/config/local.json

# do other things like babel here

EXPOSE 4000

#ENTRYPOINT ["/app/ephemer/bin/launch", "service"]
WORKDIR $BASE_DST/app
ENTRYPOINT ["node", "index.js"]

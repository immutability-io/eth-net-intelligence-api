## Dockerfile for eth-net-intelligence-api (build from git).
##
## Build via:
#
# `docker build -t ethnetintel:latest .`
#
# `docker run -d -P --name ethnetintel --network ethereum --network-alias ethnetintel local/ethnetintel:latest`
#
##

FROM keymetrics/pm2:latest

RUN apk add --no-cache bash bash-completion

ADD . /opt
WORKDIR /opt

# Install app dependencies
ENV NPM_CONFIG_LOGLEVEL warn
RUN npm install --production

CMD ["pm2-docker", "app.json"]

Ethereum Network Intelligence API
============

This is the backend service which runs along with ethereum and tracks the network status, fetches information through JSON-RPC and connects through WebSockets to [eth-netstats](https://github.com/immutability-io/eth-netstats) to feed information. For full install instructions please read the [wiki](https://github.com/ethereum/wiki/wiki/Network-Status).


## Prerequisite
The expectation is that this is used with the Docker images from Immutability's GitHub repositories:

* [Geth-based Ethereum nodes](https://github.com/immutability-org/ethereum)
* [Ethereum Netstats](https://github.com/immutability-io/eth-netstats)

## Installation as docker container

There is a `Dockerfile` in the root directory of the repository. The intent of this fork of https://github.com/cubedro/eth-net-intelligence-api is to provide a Docker container that is lightweight and easy to use with the other Immutability docker containers. Therefore this documentation is only for that use case.

## Configuration

The 'app.json.example' file contains a sample of a 2 node configuration.

```
[
  {
    "name": "ethereum-wallet",
    "cwd": ".",
    "script": "app.js",
    "log_date_format": "YYYY-MM-DD HH:mm Z",
    "merge_logs": false,
    "watch": false,
    "exec_interpreter": "node",
    "exec_mode": "fork_mode",
    "env": {
      "NODE_ENV": "private",
      "RPC_HOST": "ethereum-wallet",
      "RPC_PORT": "8545",
      "INSTANCE_NAME": "ethereum-wallet",
      "WS_SERVER": "http://ethstats:3000",
      "WS_SECRET": ""
    }
  },
  {
    "name": "ethereum-etherbase",
    "cwd": ".",
    "script": "app.js",
    "log_date_format": "YYYY-MM-DD HH:mm Z",
    "merge_logs": false,
    "watch": false,
    "exec_interpreter": "node",
    "exec_mode": "fork_mode",
    "env": {
      "NODE_ENV": "private",
      "RPC_HOST": "ethereum-etherbase",
      "RPC_PORT": "8545",
      "INSTANCE_NAME": "ethereum-etherbase",
      "WS_SERVER": "http://ethstats:3000",
      "WS_SECRET": ""
    }
  }
]

```

There are some important things to note:

* The `RPC_HOST` refers to the network alias for the 2 `geth` nodes.
* The `WS_SERVER` uses the network alias of the `eth-netstats` container.
* `WS_SECRET` needs to be configured. The **same** `WS_SECRET` needs to be configured here as with the `eth-netstats` container.

## Run

Run it using Docker:

```
$ docker pull immutability/eth-net-intelligence-api
$ docker run -d -P --name ethnetintel \
--network ethereum \
--network-alias ethnetintel \
-v /Users/secrets/app.json:/opt/app.json \
immutability/eth-net-intelligence-api:latest
```

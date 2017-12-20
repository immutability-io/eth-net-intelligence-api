Ethereum Network Intelligence API
============
[![Build Status][travis-image]][travis-url] [![dependency status][dep-image]][dep-url]

This is the backend service which runs along with ethereum and tracks the network status, fetches information through JSON-RPC and connects through WebSockets to [eth-netstats](https://github.com/cubedro/eth-netstats) to feed information. For full install instructions please read the [wiki](https://github.com/ethereum/wiki/wiki/Network-Status).


## Prerequisite
* eth, geth or pyethapp
* node
* npm


## Installation on an Ubuntu EC2 Instance

Fetch and run the build shell. This will install everything you need: latest ethereum - CLI from develop branch (you can choose between eth or geth), node.js, npm & pm2.

```bash
bash <(curl https://raw.githubusercontent.com/cubedro/eth-net-intelligence-api/master/bin/build.sh)
```
## Installation as docker container (optional)

There is a `Dockerfile` in the root directory of the repository. Please read through the header of said file for
instructions on how to build/run/setup. Configuration instructions below still apply.

## Configuration

Configure the app modifying [processes.json](/eth-net-intelligence-api/blob/master/processes.json). Note that you have to modify the backup processes.json file located in `./bin/processes.json` (to allow you to set your env vars without being rewritten when updating).

```json
"env":
	{
		"NODE_ENV"        : "production", // tell the client we're in production environment
		"RPC_HOST"        : "localhost", // eth JSON-RPC host
		"RPC_PORT"        : "8545", // eth JSON-RPC port
		"LISTENING_PORT"  : "30303", // eth listening port (only used for display)
		"INSTANCE_NAME"   : "", // whatever you wish to name your node
		"CONTACT_DETAILS" : "", // add your contact details here if you wish (email/skype)
		"WS_SERVER"       : "wss://rpc.ethstats.net", // path to eth-netstats WebSockets api server
		"WS_SECRET"       : "see http://forum.ethereum.org/discussion/2112/how-to-add-yourself-to-the-stats-dashboard-its-not-automatic", // WebSockets api server secret used for login
		"VERBOSITY"       : 2 // Set the verbosity (0 = silent, 1 = error, warn, 2 = error, warn, info, success, 3 = all logs)
	}
```

## Run

Run it using pm2:

```bash
cd ~/bin
pm2 start processes.json
```

## Updating

To update the API client use the following command:

```bash
~/bin/www/bin/update.sh
```

It will stop the current netstats client processes, automatically detect your ethereum implementation and version, update it to the latest develop build, update netstats client and reload the processes.

[travis-image]: https://travis-ci.org/cubedro/eth-net-intelligence-api.svg
[travis-url]: https://travis-ci.org/cubedro/eth-net-intelligence-api
[dep-image]: https://david-dm.org/cubedro/eth-net-intelligence-api.svg
[dep-url]: https://david-dm.org/cubedro/eth-net-intelligence-api


## More information

The monitoring system consists of two components:

eth-netstats - the monitoring site which lists the nodes.
eth-net-intelligence-api - these are processes that communicate with the ethereum client using RPC and push the data to the monitoring site via websockets.

# Monitoring site Clone the repo and install dependencies:

git clone https://github.com/cubedro/eth-netstats
cd eth-netstats
npm install
Then choose a secret and start the app:

WS_SECRET=<chosen_secret> npm start
You can now access the (empty) monitoring site at http://localhost:3000.

You can also choose a different port:

PORT=<chosen_port> WS_SECRET=<chosen_secret> npm start

# Client-side information relays These processes will relay the information from each of your cluster nodes to the monitoring site using websockets.

Clone the repo, install dependencies and make sure you have pm2 installed:

git clone https://github.com/cubedro/eth-net-intelligence-api
cd eth-net-intelligence-api
npm install
sudo npm install -g pm2
Now, use this script (netstatconf.sh) to create an app.json suitable for pm2.

## Usage:

bash netstatconf.sh <number_of_clusters> <name_prefix> <ws_server> <ws_secret>
number_of_clusters is the number of nodes in the cluster.
name_prefix is a prefix for the node names as will appear in the listing.
ws_server is the eth-netstats server. Make sure you write the full URL, for example: http://localhost:3000.
ws_secret is the eth-netstats secret.
For example:

bash netstatconf.sh 5 mynode http://localhost:3000 big-secret > app.json
Run the script and copy the resulting app.json into the eth-net-intelligence-api directory. Afterwards, cd into eth-net-intelligence-api and run the relays using pm2 start app.json. To stop the relays, you can use pm2 delete app.json.

NOTE: The script assumes the nodes have RPC ports 8101, 8102, ... . If that's not the case, edit app.json and change it accordingly for each peer.

At this point, open http://localhost:3000 and your monitoring site should monitor all your nodes!

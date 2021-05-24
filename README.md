# cncli-docker

## build

```bash
docker-compose build
```

## configure docker-compose.yml

### service sync

Adapt `--host 49.12.86.157 --port 3001` to a node of your trust in docker-compose.yml.

### service leaderlog

Adapt docker-compsoe.yml so the `/keys` volume contains `vrf.skey`, `mainnet-byron-genesis.json` and `mainnet-shelley-genesis.json`.

Adapt pool id in docker-compsoe.yml `--pool-id 3bd3996595321d951291b11e1331061c5d8659d9e69390536dfc922c`.

## start cncli syn

This is a service which needs to run.

```bash
docker-compose up -d
```
## Create leaderlog

### create ledgerstate

if you run your node as docker you can use this to create `ledgerstate.json`.
```bash
sudo docker run --rm -ti -e CARDANO_NODE_SOCKET_PATH=/ipc/node.socket -v pool_relay1-ipc:/ipc --entrypoint /bin/bash inputoutput/cardano-node -c "cardano-cli query ledger-state --mainnet" > ledgerstate/ledgerstate.json
```

the ledgerstate.json has to be placed in the mounted `ledgerstate` directory.

### generate leaderlog

LOG can be `prev`, `current` or `next`. In most cases you run `next` 1.5 days before the next epoch starts.

```bash
sudo LOG=next docker-compose run leaderlog
```






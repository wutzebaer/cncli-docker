POOL_ID=3bd3996595321d951291b11e1331061c5d8659d9e69390536dfc922c

echo "Build image"
sudo docker build -t cncli .

echo "Sync DB"
sudo docker run --rm -v $(pwd)/db:/db cncli cncli sync --host 49.12.86.157 --port 3001 -d /db/cncli.db --no-service

echo "Create stake-snapshot"
SNAPSHOT=$(sudo docker run --rm -ti -e CARDANO_NODE_SOCKET_PATH=/ipc/node.socket -v pool_relay1-ipc:/ipc --entrypoint /bin/bash inputoutput/cardano-node -c "cardano-cli query stake-snapshot --stake-pool-id $POOL_ID --mainnet")
POOL_STAKE=$(jq .poolStakeMark <<< $SNAPSHOT)
ACTIVE_STAKE=$(jq .activeStakeMark <<< $SNAPSHOT)
echo $POOL_STAKE
echo $ACTIVE_STAKE

echo "Generate leaderlog"
BCSH=$(sudo docker run -v $(pwd)/db:/db -v $(pwd)/keys:/keys cncli cncli leaderlog --pool-id $POOL_ID --pool-vrf-skey /keys/vrf.skey --byron-genesis /keys/mainnet-byron-genesis.json --shelley-genesis /keys/mainnet-shelley-genesis.json --pool-stake $POOL_STAKE --active-stake $ACTIVE_STAKE --ledger-set next -d /db/cncli.db)

jq <<< $BCSH

EPOCH=`jq .epoch <<< $BCSH`
echo "\`Epoch $EPOCH\` 🧙🔮:"

SLOTS=`jq .epochSlots <<< $BCSH`
IDEAL=`jq .epochSlotsIdeal <<< $BCSH`
PERFORMANCE=`jq .maxPerformance <<< $BCSH`
echo "\`BCSH  - $SLOTS \`🎰\`,  $PERFORMANCE% \`🍀max, \`$IDEAL\` 🧱ideal"
echo "Export ledger"
./ledgerstate.sh
echo "Prev"
#sudo LOG=prev docker-compose run leaderlog
echo "Current"
#sudo LOG=current docker-compose run leaderlog
echo "Next"
sudo LOG=next docker-compose run leaderlog

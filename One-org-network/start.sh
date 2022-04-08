
./destroy-network.sh

bash ./create-artifacts.sh
sleep 2
cat ./scripts/start-network.sh | docker exec -i cli bash
sleep 2
cat ./scripts/chaincode.sh | docker exec -i cli bash

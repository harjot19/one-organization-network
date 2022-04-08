#environment variables for peers

export CHANNEL_NAME=mychannel

envVarPeer0TCS () {
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/tcs.example.com/users/Admin@tcs.example.com/msp
    CORE_PEER_ADDRESS=peer0.tcs.example.com:7051
    CORE_PEER_LOCALMSPID="tcsMSP"
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/tcs.example.com/peers/peer0.tcs.example.com/tls/ca.crt
    
}

envVarPeer0WIPRO () {
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wipro.example.com/users/Admin@wipro.example.com/msp 
    CORE_PEER_ADDRESS=peer0.wipro.example.com:9051 
    CORE_PEER_LOCALMSPID="wiproMSP" 
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wipro.example.com/peers/peer0.wipro.example.com/tls/ca.crt
    
}

installChaincode () {
    echo "Installing chaincode on peer0 of TCS"
    envVarPeer0TCS
    peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/chaincode_example02/go/
    output=$?
    if [ $output -ne 0 ]; then 
        echo "chaincode not installed on peer"
                echo "**********************************************"

        exit 1
    else
        echo "chaincode installed on peer"  
                echo "**********************************************"
  
    fi 

   }

# instatiating chaincode
instatiateChaincode () {
    
    peer chaincode instantiate -o orderer.example.com:7050 --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "OR ('tcsMSP.peer')"
    output=$?
    if [ $output -ne 0 ]; then 
        echo "chaincode not instatiated"
                echo "**********************************************"

        exit 1
    else
        echo "chaincode succesfully instatiated"   
                echo "**********************************************"
 
    fi 
}

# querying chaincode
query () {
    envVarPeer0TCS
    peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'
    output=$?
    if [ $output -ne 0 ]; then 
        echo "query not run"
                echo "**********************************************"

        exit 1
    else
        echo "query runs"    
                echo "**********************************************"

    fi 
}

# invoking
invokingChaincode () {
    peer chaincode invoke -o orderer.example.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C $CHANNEL_NAME -n mycc --peerAddresses peer0.tcs.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/tcs.example.com/peers/peer0.tcs.example.com/tls/ca.crt -c '{"Args":["invoke","a","b","10"]}'
     output=$?
    if [ $output -ne 0 ]; then 
        echo "invoke did not run"
                echo "**********************************************"

        exit 1
    else
        echo "invoke query runs" 
                echo "**********************************************"
   
    fi 
}


# calling functions
installChaincode
sleep 2
instatiateChaincode
sleep 5 
echo "quering chaincode"
query
invokingChaincode
sleep 3
# # again query the chaincode
query

envVarPeer1WIPRO () {
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wipro.example.com/users/Admin@wipro.example.com/msp 
    CORE_PEER_ADDRESS=peer1.wipro.example.com:9051 
    CORE_PEER_LOCALMSPID="wiproMSP" 
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/wipro.example.com/peers/peer0.wipro.example.com/tls/ca.crt
    
}

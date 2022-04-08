    export CHANNEL_NAME=mychannel




# ****************** function for create channel
# **********************************************
function createChannel () {
    peer channel create -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
    output=$?
    if [ $output -ne 0 ]; then 
        echo "failed to create chanel"
                echo "**********************************************"

        exit 1
    fi    
}

#  functions for env variables for different peers

envVarPeer0TCS () {
    CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/tcs.example.com/users/Admin@tcs.example.com/msp
    CORE_PEER_ADDRESS=peer0.tcs.example.com:7051
   
    CORE_PEER_LOCALMSPID=tcsMSP
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/tcs.example.com/peers/peer0.tcs.example.com/tls/ca.crt

}


# ****************** function for join channel
function joinChannel () {
    # here default peer will be joined in channel
    peer channel join -b mychannel.block
    output=$?
    if [ $output -ne 0 ]; then 
        echo "failed to join peer"
        echo "**********************************************"
        exit 1
    fi 
}


# **************** update anchor peers

updateAnchorPeers(){
    envVarPeer0TCS 
    peer channel update -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/tcsMSPanchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
     output=$?
    if [ $output -ne 0 ]; then 
        echo "failed to update peer"
                echo "**********************************************"

        exit 1
    fi 
}


createChannel
sleep 2
joinChannel
sleep 2
updateAnchorPeers




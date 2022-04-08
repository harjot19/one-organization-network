#!/bin/sh


# function for generating certificates
SYS_CHANNEL="byfn-sys-channel"
export CHANNEL_NAME=mychannel
CONSENSUS="solo"

function generateCerts () {
    echo "*************** Generating  certificates*********************"
    # if [ -d "crypto-config" ]; then
    #     rm -rf crypto-config
    # fi
    cryptogen generate --config=./crypto-config.yaml
    output=$?

    if [ $output -ne 0 ]; then
        echo "certificates not generated"
    else
        echo "certificates generated" 
    fi       
}

# function for channel artifacts
function channelArtifacts () {
    export FABRIC_CFG_PATH=$PWD

    # ************ generating order geneis block ******************
    if [ "$CONSENSUS" == "solo" ]; then
        configtxgen -profile OneOrgOrdererGenesis -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
    fi
    output=$?
    if [ $output -ne 0 ]; then
        echo "********************genesis block not generated**************"
    else
        echo "********************genesis block generated*******************" 
    fi    

    echo "********************** generating channel.tx***********************"
        configtxgen -profile OneOrgChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
    output=$?
    if [ $output -ne 0 ]; then
        echo "********************channel configuration not generated**************"
    else
        echo "********************channel configuration generated*******************" 
    fi    

        echo "************generating anchor peers for both tcs and wipro************"
   
    # ############################ for TCS
    configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./channel-artifacts/tcsMSPanchors.tx -channelID $CHANNEL_NAME -asOrg tcsMSP
    output=$?
    if [ $output -ne 0 ]; then
        echo "********************anchor peer for tcs not generated**************"
    else
        echo "********************anchor peer for tcs generated*******************" 
    fi    
}

# Delete existing artifacts
if [ ! -d "crypto-config" ]; then
    echo "crypto-config folder not existed"
    generateCerts
# else
#     # rm -rf crypto-config
#     # generateCerts
#     exit 1
fi


# calling channelartifacts function for genesis block
channelArtifacts

#  network up
echo ""
echo "********************** network up *******************"
docker-compose -f docker-compose-cli.yaml up -d

# *************************** entering cli container
# docker exec -it cli bash




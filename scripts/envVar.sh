#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/msp/tlscacerts/tlsca.universidades.com-cert.pem
export PEER0_Madrid_CA=${PWD}/organizations/peerOrganizations/madrid.universidades.com/peers/peer0.madrid.universidades.com/tls/ca.crt
export PEER0_BOGOTA_CA=${PWD}/organizations/peerOrganizations/bogota.universidades.com/peers/peer0.bogota.universidades.com/tls/ca.crt
export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls/ca.crt
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/universidades.com/orderers/orderer.universidades.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=$1
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG = "madrid" ]; then
    export CORE_PEER_LOCALMSPID="MadridMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_Madrid_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/madrid.universidades.com/users/Admin@madrid.universidades.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG = "bogota" ]; then
    export CORE_PEER_LOCALMSPID="BogotaMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_BOGOTA_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/bogota.universidades.com/users/Admin@bogota.universidades.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  elif [ $USING_ORG = "ecuador" ]; then
    export CORE_PEER_LOCALMSPID="EcuadorMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG3_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/ecuador.universidades.com/users/Admin@ecuador.universidades.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container 
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG = "madrid" ]; then
    export CORE_PEER_ADDRESS=peer0.madrid.universidades.com:7051
  elif [ $USING_ORG = "bogota" ]; then
    export CORE_PEER_ADDRESS=peer0.bogota.universidades.com:9051
  elif [ $USING_ORG = "ecuador" ]; then
    export CORE_PEER_ADDRESS=peer0.ecuador.universidades.com:11051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()
  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    PEER="peer0.$1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=PEER0_$1_CA
    TLSINFO=(--tlsRootCertFiles "${!CA}")
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}

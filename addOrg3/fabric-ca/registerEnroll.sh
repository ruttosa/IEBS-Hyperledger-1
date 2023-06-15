#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

function createEcuador {
	infoln "Enrolling the CA admin"
	mkdir -p ../organizations/peerOrganizations/ecuador.universidades.com/

	export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-ecuador --tls.certfiles "${PWD}/fabric-ca/ecuador/tls-cert.pem"
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-ecuador.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-ecuador.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-ecuador.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-ecuador.pem
    OrganizationalUnitIdentifier: orderer' > "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/msp/config.yaml"

	infoln "Registering peer0"
  set -x
	fabric-ca-client register --caname ca-ecuador --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles "${PWD}/fabric-ca/ecuador/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering user"
  set -x
  fabric-ca-client register --caname ca-ecuador --id.name user1 --id.secret user1pw --id.type client --tls.certfiles "${PWD}/fabric-ca/ecuador/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Registering the org admin"
  set -x
  fabric-ca-client register --caname ca-ecuador --id.name ecuadoradmin --id.secret ecuadoradminpw --id.type admin --tls.certfiles "${PWD}/fabric-ca/ecuador/tls-cert.pem"
  { set +x; } 2>/dev/null

  infoln "Generating the peer0 msp"
  set -x
	fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-ecuador -M "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/msp" --csr.hosts peer0.ecuador.universidades.com --tls.certfiles "${PWD}/fabric-ca/ecuador/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/msp/config.yaml" "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/msp/config.yaml"

  infoln "Generating the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-ecuador -M "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls" --enrollment.profile tls --csr.hosts peer0.ecuador.universidades.com --csr.hosts localhost --tls.certfiles "${PWD}/fabric-ca/ecuador/tls-cert.pem"
  { set +x; } 2>/dev/null


  cp "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls/tlscacerts/"* "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls/ca.crt"
  cp "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls/signcerts/"* "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls/server.crt"
  cp "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls/keystore/"* "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls/server.key"

  mkdir "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/msp/tlscacerts"
  cp "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls/tlscacerts/"* "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/msp/tlscacerts/ca.crt"

  mkdir "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/tlsca"
  cp "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/tls/tlscacerts/"* "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/tlsca/tlsca.ecuador.universidades.com-cert.pem"

  mkdir "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/ca"
  cp "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/peers/peer0.ecuador.universidades.com/msp/cacerts/"* "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/ca/ca.ecuador.universidades.com-cert.pem"

  infoln "Generating the user msp"
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-ecuador -M "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/users/User1@ecuador.universidades.com/msp" --tls.certfiles "${PWD}/fabric-ca/ecuador/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/msp/config.yaml" "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/users/User1@ecuador.universidades.com/msp/config.yaml"

  infoln "Generating the org admin msp"
  set -x
	fabric-ca-client enroll -u https://ecuadoradmin:ecuadoradminpw@localhost:11054 --caname ca-ecuador -M "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/users/Admin@ecuador.universidades.com/msp" --tls.certfiles "${PWD}/fabric-ca/ecuador/tls-cert.pem"
  { set +x; } 2>/dev/null

  cp "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/msp/config.yaml" "${PWD}/../organizations/peerOrganizations/ecuador.universidades.com/users/Admin@ecuador.universidades.com/msp/config.yaml"
}

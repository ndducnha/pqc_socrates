

docker exec -ti moon /bin/bash


docker exec -ti carol /bin/bash



cd /home/vboxuser/Documents/
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images | grep -E 'vpnsocrates' | awk '{print $3}')
docker build --no-cache -t vpnsocrates .
cd docker/pq-strongswan
docker-compose up

docker exec -ti moon /bin/bash  
apt update
apt install binutils -y
./charon

docker exec -ti carol /bin/bash
apt update
apt install binutils -y
./charon

docker exec -ti carol /bin/bash
swanctl --initiate --child net > /dev/null

swanctl --initiate --child host > /dev/null

Generate RSA certificate:

pki --gen --outform pem > caKeyRSA.pem

pki --self --type priv --in caKeyRSA.pem --ca --lifetime 3652 \
    --dn "C=CH, O=Cyber, CN=Cyber Root CA"                  \
    --outform pem > caCertRSA.pem

pki --gen --outform pem > moonKeyRSA.pem

pki --issue --cacert caCertRSA.pem --cakey caKeyRSA.pem   \
    --type priv --in moonKeyRSA.pem --lifetime 1461 \
    --dn "C=CH, O=Cyber, CN=moon.strongswan.org"    \
    --san moon.strongswan.org --outform pem > moonCertRSA.pem

pki --gen --outform pem > carolKeyRSA.pem

pki --issue --cacert caCertRSA.pem --cakey caKeyRSA.pem    \
     --type priv --in carolKeyRSA.pem --lifetime 1461 \
     --dn "C=CH, O=Cyber, CN=carol@strongswan.org"  \
     --san carol@strongswan.org --outform pem > carolCertRSA.pem
     
Generate FALCON certificate:

pki --gen --type falcon1024 --outform pem > caKeyFalcon.pem

pki --self --type priv --in caKeyFalcon.pem --ca --lifetime 3652 \
    --dn "C=CH, O=Cyber, CN=Cyber Root CA"                  \
    --outform pem > caCertFalcon.pem

pki --gen --type falcon1024 --outform pem > moonKeyFalcon.pem

pki --issue --cacert caCertFalcon.pem --cakey caKeyFalcon.pem   \
    --type priv --in moonKeyFalcon.pem --lifetime 1461 \
    --dn "C=CH, O=Cyber, CN=moon.strongswan.org"    \
    --san moon.strongswan.org --outform pem > moonCertFalcon.pem

pki --gen --type falcon1024 --outform pem > carolKeyFalcon.pem

pki --issue --cacert caCertFalcon.pem --cakey caKeyFalcon.pem    \
     --type priv --in carolKeyFalcon.pem --lifetime 1461 \
     --dn "C=CH, O=Cyber, CN=carol@strongswan.org"  \
     --san carol@strongswan.org --outform pem > carolCertFalcon.pem
     
     
Generate # Generate ECDSA key pair for CA
pki --gen --type ecdsa --outform pem > caKeyECDSA.pem

# Self-sign the CA certificate
pki --self --type priv --in caKeyECDSA.pem --ca --lifetime 3652 \
    --dn "C=CH, O=Cyber, CN=Cyber Root CA"                  \
    --outform pem > caCertECDSA.pem

# Generate ECDSA key pair for moon.strongswan.org
pki --gen --type ecdsa --outform pem > moonKeyECDSA.pem

# Issue certificate for moon.strongswan.org
pki --issue --cacert caCertECDSA.pem --cakey caKeyECDSA.pem   \
    --type priv --in moonKeyECDSA.pem --lifetime 1461 \
    --dn "C=CH, O=Cyber, CN=moon.strongswan.org"    \
    --san moon.strongswan.org --outform pem > moonCertECDSA.pem

# Generate ECDSA key pair for carol@strongswan.org
pki --gen --type ecdsa --outform pem > carolKeyECDSA.pem

# Issue certificate for carol@strongswan.org
pki --issue --cacert caCertECDSA.pem --cakey caKeyECDSA.pem    \
     --type priv --in carolKeyECDSA.pem --lifetime 1461 \
     --dn "C=CH, O=Cyber, CN=carol@strongswan.org"  \
     --san carol@strongswan.org --outform pem > carolCertECDSA.pem


# Generate ED25519 key pair for CA
pki --gen --type ed25519 --outform pem > caKeyED25519.pem

pki --self --type priv --in caKeyED25519.pem --ca --lifetime 3652 \
    --dn "C=CH, O=Cyber, CN=Cyber Root CA"                  \
    --outform pem > caCertED25519.pem

pki --gen --type ed25519 --outform pem > moonKeyED25519.pem

pki --issue --cacert caCertED25519.pem --cakey caKeyED25519.pem   \
    --type priv --in moonKeyED25519.pem --lifetime 1461 \
    --dn "C=CH, O=Cyber, CN=moon.strongswan.org"    \
    --san moon.strongswan.org --outform pem > moonCertED25519.pem

pki --gen --type ed25519 --outform pem > carolKeyED25519.pem

pki --issue --cacert caCertED25519.pem --cakey caKeyED25519.pem    \
     --type priv --in carolKeyED25519.pem --lifetime 1461 \
     --dn "C=CH, O=Cyber, CN=carol@strongswan.org"  \
     --san carol@strongswan.org --outform pem > carolCertED25519.pem
     

     

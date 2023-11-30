

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
     --dn "C=CH, O=Cyber, CN=carol@strongswan.org1"  \
     --san carol@strongswan.org1 --outform pem > carolCertRSA.pem
     

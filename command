docker exec -ti moon /bin/bash  
apt update
apt install binutils -y
./charon

docker exec -ti carol /bin/bash
apt update
apt install binutils -y
./charon

cd /home/vboxuser/Documents/
docker rm -f $(docker ps -aq)
docker rmi -f $(docker images | grep -E 'vpnsocrates' | awk '{print $3}')
docker build --no-cache -t vpnsocrates .
cd docker/pq-strongswan
docker-compose up

docker network inspect pq-strongswan_internet

docker rm $(docker ps -a -q)

docker-compose up --build


docker cp test_scripts.sh 935de92ccab1:/

chmod 777 test_scripts.sh
./test_scripts.sh 2>&1 | tee Falcon1024_only.txt

docker cp 935de92ccab1:/Falcon1024_only.txt ./results

swanctl --initiate --child net > /dev/null
swanctl --initiate --child host > /dev/null

tc qdisc add dev eth0 root netem delay 10ms rate 50mbit

tc qdisc del dev eth0 root

swanctl --terminate --child host > /dev/null
swanctl --terminate --child net > /dev/null

# change network conditions:

tc qdisc add dev eth0 root netem delay 150ms rate 20mbit

tc qdisc del dev eth0 root

tc qdisc add dev eth0 root netem delay 80ms rate 60mbit

tc qdisc del dev eth0 root

tc qdisc add dev eth0 root netem delay 20ms rate 100mbit

tc qdisc del dev eth0 root


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
     

Generate FALCON512 certificate:

pki --gen --type falcon512 --outform pem > caKeyFalcon512.pem

pki --self --type priv --in caKeyFalcon512.pem --ca --lifetime 3652 \
    --dn "C=CH, O=Cyber, CN=Cyber Root CA"                  \
    --outform pem > caCertFalcon512.pem

pki --gen --type falcon512 --outform pem > moonKeyFalcon512.pem

pki --issue --cacert caCertFalcon512.pem --cakey caKeyFalcon512.pem   \
    --type priv --in moonKeyFalcon512.pem --lifetime 1461 \
    --dn "C=CH, O=Cyber, CN=moon.strongswan.org"    \
    --san moon.strongswan.org --outform pem > moonCertFalcon512.pem

pki --gen --type falcon512 --outform pem > carolKeyFalcon512.pem

pki --issue --cacert caCertFalcon512.pem --cakey caKeyFalcon512.pem    \
     --type priv --in carolKeyFalcon512.pem --lifetime 1461 \
     --dn "C=CH, O=Cyber, CN=carol@strongswan.org"  \
     --san carol@strongswan.org --outform pem > carolCertFalcon512.pem
     
Generate DILITHIUM2 certificate:

pki --gen --type dilithium2 --outform pem > caKeyDilithium2.pem

pki --self --type priv --in caKeyDilithium2.pem --ca --lifetime 3652 \
    --dn "C=CH, O=Cyber, CN=Cyber Root CA"                  \
    --outform pem > caCertDilithium2.pem

pki --gen --type dilithium2 --outform pem > moonKeyDilithium2.pem

pki --issue --cacert caCertDilithium2.pem --cakey caKeyDilithium2.pem   \
    --type priv --in moonKeyDilithium2.pem --lifetime 1461 \
    --dn "C=CH, O=Cyber, CN=moon.strongswan.org"    \
    --san moon.strongswan.org --outform pem > moonCertDilithium2.pem

pki --gen --type dilithium2 --outform pem > carolKeyDilithium2.pem

pki --issue --cacert caCertDilithium2.pem --cakey caKeyDilithium2.pem    \
     --type priv --in carolKeyDilithium2.pem --lifetime 1461 \
     --dn "C=CH, O=Cyber, CN=carol@strongswan.org"  \
     --san carol@strongswan.org --outform pem > carolCertDilithium2.pem
     
Generate DILITHIUM3 certificate:

pki --gen --type dilithium3 --outform pem > caKeyDilithium3.pem

pki --self --type priv --in caKeyDilithium3.pem --ca --lifetime 3652 \
    --dn "C=CH, O=Cyber, CN=Cyber Root CA"                  \
    --outform pem > caCertDilithium3.pem

pki --gen --type dilithium3 --outform pem > moonKeyDilithium3.pem

pki --issue --cacert caCertDilithium3.pem --cakey caKeyDilithium3.pem   \
    --type priv --in moonKeyDilithium3.pem --lifetime 1461 \
    --dn "C=CH, O=Cyber, CN=moon.strongswan.org"    \
    --san moon.strongswan.org --outform pem > moonCertDilithium3.pem

pki --gen --type dilithium3 --outform pem > carolKeyDilithium3.pem

pki --issue --cacert caCertDilithium3.pem --cakey caKeyDilithium3.pem    \
     --type priv --in carolKeyDilithium3.pem --lifetime 1461 \
     --dn "C=CH, O=Cyber, CN=carol@strongswan.org"  \
     --san carol@strongswan.org --outform pem > carolCertDilithium3.pem
     
     
Generate SPHINCS256 certificate:

pki --gen --type sphincs256 --outform pem > caKeySPHINCS.pem

pki --self --type priv --in caKeySPHINCS.pem --ca --lifetime 3652 \
    --dn "C=CH, O=Cyber, CN=Cyber Root CA"                  \
    --outform pem > caCertSPHINCS.pem

pki --gen --type sphincs256 --outform pem > moonKeySPHINCS.pem

pki --issue --cacert caCertSPHINCS.pem --cakey caKeySPHINCS.pem   \
    --type priv --in moonKeySPHINCS.pem --lifetime 1461 \
    --dn "C=CH, O=Cyber, CN=moon.strongswan.org"    \
    --san moon.strongswan.org --outform pem > moonCertSPHINCS.pem

pki --gen --type sphincs256 --outform pem > carolKeySPHINCS.pem

pki --issue --cacert caCertSPHINCS.pem --cakey caKeySPHINCS.pem    \
     --type priv --in carolKeySPHINCS.pem --lifetime 1461 \
     --dn "C=CH, O=Cyber, CN=carol@strongswan.org"  \
     --san carol@strongswan.org --outform pem > carolCertSPHINCS.pem
     
docker swarm join --token SWMTKN-1-19na7hssc15ji9c43101lqcjcnyggjkhii9jm6hcv9q760pc14-8o0s1fvo6dfqb6puwc48ll173 192.168.0.3:2377

 ## Docker-compose moon

version: "3"

services:
  moon:
    image: vpnsocrates:latest
#    network_mode: "host"
    ports:
      - "500:500/tcp"
      - "4500:4500/tcp"
      - "12345:12345/tcp"
      - "500:500/udp"
      - "4500:4500/udp"
      - "12345:12345/udp"
    container_name: moon
    cap_add:
      - NET_ADMIN
      - SYS_ADMIN                                         
      - SYS_MODULE
    stdin_open: true
    tty: true
    volumes:
      - ./moon:/etc/swanctl
      - ./strongswan.conf:/etc/strongswan.conf
    networks:
      internet:
         ipv4_address: 34.129.68.11
      intranet:
         ipv4_address: 10.98.0.4
networks:
  internet:
    ipam:
      driver: default
      config:
        - subnet: 34.129.68.0/24
  intranet:
     ipam:
        driver: default
        config:
          - subnet: 10.0.0.0/8

## Docker-compose client

version: "3"

services:
  carol:
    image: vpnsocrates:latest
    container_name: carol
    ports:
      - "500:500/tcp"
      - "4500:4500/tcp"
      - "12345:12345/tcp"
      - "500:500/udp"
      - "4500:4500/udp"
      - "12345:12345/udp"
    cap_add:
      - NET_ADMIN
      - SYS_ADMIN
      - SYS_MODULE
    stdin_open: true
    tty: true
    volumes:
      - ./carol:/etc/swanctl
      - ./strongswan.conf:/etc/strongswan.conf
    networks:
      internet:
         ipv4_address: 34.135.103.65

networks:
  internet:
    ipam:
      driver: default 
      config:
        - subnet: 34.135.103.0/24
  intranet:
     ipam:
        driver: default
        config:
          - subnet: 10.0.0.0/8 

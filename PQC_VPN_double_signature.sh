#!/bin/bash

# Launch new terminal and execute Docker commands
gnome-terminal -- bash -c "cd /home/vboxuser/Documents/; \
                           docker rm -f \$(docker ps -aq); \
                           docker rmi -f \$(docker images | grep -E 
'vpnsocrates' | awk '{print \$3}'); \
                           docker build --no-cache -t vpnsocrates .; \
                           cd docker/pq-strongswan; \
                           docker-compose up; \
                           exec bash"

# Wait for a few seconds to allow the previous commands to initialize
sleep 10

# Function to run expect script for root commands
run_expect_script() {
    /usr/bin/expect <<EOF
    set timeout 20
    spawn gnome-terminal -- bash -c "su root"
    expect "Password:"
    send "Aqwerty@13\r"
    send "$1\r"
    interact
EOF
}

# Commands to be executed as root in different terminals
CMD1="docker exec -ti moon /bin/bash; apt update; apt install binutils -y; 
./charon"
CMD2="docker exec -ti carol /bin/bash; apt update; apt install binutils 
-y; ./charon"
CMD3="docker exec -ti carol /bin/bash; swanctl --initiate --child net > 
/dev/null"

# Run the commands in separate terminals
run_expect_script "$CMD1"
sleep 2
run_expect_script "$CMD2"
sleep 2
run_expect_script "$CMD3"


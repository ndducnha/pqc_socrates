#!/bin/bash

# Function to set up network conditions and establish the VPN connection
establish_connection() {
    local scenario=$1
    local bandwidth_limit
    local latency_limit
    local key_type1_str
    local key_type2_str

    case $scenario in
        1)
            bandwidth_limit="10mbit"
            latency_limit="150ms"
            ;;
        2)
            bandwidth_limit="70mbit"
            latency_limit="100ms"
            ;;
        3)
            bandwidth_limit="90mbit"
            latency_limit="50ms"
            ;;
        4)
            bandwidth_limit="200mbit"
            latency_limit="10ms"
            ;;
        *)
            echo "Invalid scenario"
            exit 1
            ;;
    esac

    # Apply the network conditions using tc
    sudo tc qdisc add dev eth0 root handle 1: htb default 30
    sudo tc class add dev eth0 parent 1: classid 1:1 htb rate $bandwidth_limit
    sudo tc qdisc add dev eth0 parent 1:1 handle 10: netem delay $latency_limit

    # Wait for network changes to take effect
    sleep 4

    # Read actual values from network_status.txt
    if [ -f "/network_status.txt" ]; then
        read -r bandwidth latency < /network_status.txt
        echo "Current network condition: Bandwidth = $bandwidth Mbps, Latency = $latency ms"
    else
        echo "network_status.txt not found"
        exit 1
    fi

    # Determine key combinations based on network conditions
    if (( $(echo "$bandwidth < 50" | bc -l) )) && (( $(echo "$latency > 100" | bc -l) )); then
        key_type1_str="KEY_ED25519"
        key_type2_str="KEY_FALCON_512"
    elif (( $(echo "$bandwidth < 75" | bc -l) )) && (( $(echo "$latency > 75" | bc -l) )); then
        key_type1_str="KEY_ECDSA_256"
        key_type2_str="KEY_DILITHIUM_2"
    elif (( $(echo "$bandwidth >= 50 && $bandwidth <= 75" | bc -l) )) && (( $(echo "$latency >= 75 && $latency <= 100" | bc -l) )); then
        key_type1_str="KEY_ED25519"
        key_type2_str="KEY_DILITHIUM_2"
    elif (( $(echo "$bandwidth >= 75 && $bandwidth <= 100" | bc -l) )) && (( $(echo "$latency >= 50 && $latency <= 100" | bc -l) )); then
        key_type1_str="KEY_ED25519"
        key_type2_str="KEY_DILITHIUM_3"
    elif (( $(echo "$bandwidth > 100" | bc -l) )) && (( $(echo "$latency < 50" | bc -l) )); then
        key_type1_str="KEY_RSA_2048"
        key_type2_str="KEY_FALCON_1024"
    else
        key_type1_str="KEY_RSA_2048"
        key_type2_str="KEY_FALCON_1024"
    fi

    echo "Selected Keys: $key_type1_str (Traditional), $key_type2_str (PQC)"

    # Terminate the previous charon process if it exists
    if pgrep charon > /dev/null; then
        sudo pkill charon
    fi

    # Start charon in the background and establish the VPN connection
    sudo ./charon &
    sleep 2  # Give charon some time to start
    sudo swanctl --initiate --child net > /dev/null
    sudo swanctl --initiate --child host > /dev/null

    echo "VPN connection established for scenario $scenario"
}

while true; do
    echo "Choose an option:"
    echo "1. Establish connection from VPN client to VPN server. (scenario 1)"
    echo "2. Establish connection from VPN client to VPN server. (scenario 2)"
    echo "3. Establish connection from VPN client to VPN server. (scenario 3)"
    echo "4. Establish connection from VPN client to VPN server. (scenario 4)"
    echo "5. End"
    read -p "Choose: " choice

    case $choice in
        1|2|3|4)
            establish_connection $choice
            ;;
        5)
            echo "Ending script."
            exit 0
            ;;
        *)
            echo "Invalid option, please choose again."
            ;;
    esac
done

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
            bandwidth_limit="30mbit"
            latency_limit="130ms"
            ;;
        2)
            bandwidth_limit="50mbit"
            latency_limit="85ms"
            ;;
        3)
            bandwidth_limit="85mbit"
            latency_limit="75ms"
            ;;
        4)
            bandwidth_limit="150mbit"
            latency_limit="10ms"
            ;;
        *)
            echo "Invalid scenario"
            exit 1
            ;;
    esac

    # Remove existing tc qdisc settings
    tc qdisc del dev eth0 root 2>/dev/null

    # Apply the new network conditions using tc
    tc qdisc add dev eth0 root netem rate $bandwidth_limit delay $latency_limit

    # Wait for network changes to take effect
    sleep 2

    # Read actual values from network_status.txt
    if [ -f "/network_status.txt" ]; then
        read -r bandwidth latency < /network_status.txt
        echo "Current network condition: Bandwidth = $bandwidth Mbps, Latency = $latency ms"
    else
        echo "network_status.txt not found"
        exit 1
    fi

    # Ensure bandwidth and latency are not empty
    bandwidth=${bandwidth:-0}
    latency=${latency:-0}

    # Convert bandwidth and latency to integers for comparison
    bandwidth_int=$(printf "%.0f" "$bandwidth")
    latency_int=$(printf "%.0f" "$latency")

    # Determine key combinations based on network conditions
    if [ "$bandwidth_int" -lt 50 ] && [ "$latency_int" -gt 100 ]; then
        key_type1_str="KEY_ED25519"
        key_type2_str="KEY_FALCON_512"
    elif [ "$bandwidth_int" -lt 75 ] && [ "$latency_int" -gt 75 ]; then
        key_type1_str="KEY_ECDSA_256"
        key_type2_str="KEY_DILITHIUM_2"
    elif [ "$bandwidth_int" -ge 50 ] && [ "$bandwidth_int" -le 75 ] && [ "$latency_int" -ge 75 ] && [ "$latency_int" -le 100 ]; then
        key_type1_str="KEY_ED25519"
        key_type2_str="KEY_DILITHIUM_2"
    elif [ "$bandwidth_int" -ge 75 ] && [ "$bandwidth_int" -le 100 ] && [ "$latency_int" -ge 50 ] && [ "$latency_int" -le 100 ]; then
        key_type1_str="KEY_ED25519"
        key_type2_str="KEY_DILITHIUM_3"
    elif [ "$bandwidth_int" -gt 100 ] && [ "$latency_int" -lt 50 ]; then
        key_type1_str="KEY_RSA_2048"
        key_type2_str="KEY_FALCON_1024"
    else
        key_type1_str="KEY_RSA_2048"
        key_type2_str="KEY_FALCON_1024"
    fi

    echo "Selected Keys: $key_type1_str, $key_type2_str"

    # Terminate the previous charon process if it exists
    if pgrep charon > /dev/null; then
        pkill charon
    fi

    # Start charon in the background and redirect output to /dev/null
    ./charon > /dev/null 2>&1 &
    sleep 2  # Give charon some time to start
    swanctl --initiate --child net > /dev/null
    swanctl --initiate --child host > /dev/null

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

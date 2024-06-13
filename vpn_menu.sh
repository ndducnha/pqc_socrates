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
            echo "*****************************************"
            echo "* SOCRATES WP5 - Level 1 *"
            echo "*****************************************"
            bandwidth_limit="30mbit"
            latency_limit="130ms"
            echo "Establishing connection with Level 1 conditions..."
            ;;
        3)
            echo "*****************************************"
            echo "* SOCRATES WP5 - Level 3 *"
            echo "*****************************************"
            bandwidth_limit="85mbit"
            latency_limit="75ms"
            echo "Establishing connection with Level 3 conditions..."
            ;;
        5)
            echo "*****************************************"
            echo "* SOCRATES WP5 - Level 5 *"
            echo "*****************************************"
            bandwidth_limit="180mbit"
            latency_limit="10ms"
            echo "Establishing connection with Level 5 conditions..."
            ;;
        6)
            echo "*****************************************"
            echo "* SOCRATES WP5 - Mobility *"
            echo "*****************************************"
            echo "Starting with first conditions..."
            change_network_conditions "30mbit" "130ms"
            sleep 5
            # echo "Changing to Level 3 conditions..."
            change_network_conditions "85mbit" "75ms"
            sleep 5
            # echo "Changing to Level 5 conditions..."
            change_network_conditions "180mbit" "10ms"
            sleep 5
            echo "Mobility test completed."
            return
            ;;
        *)
            echo "Invalid scenario"
            exit 1
            ;;
    esac

    apply_network_conditions_and_establish_connection "$bandwidth_limit" "$latency_limit" $scenario
}

change_network_conditions() {
    local bandwidth_limit=$1
    local latency_limit=$2

    # Remove existing tc qdisc settings
    tc qdisc del dev eth0 root 2>/dev/null

    # Apply the new network conditions using tc
    tc qdisc add dev eth0 root netem rate $bandwidth_limit delay $latency_limit

    # Wait for network changes to take effect
    sleep 6

    # Read actual values from network_status.txt
    if [ -f "/network_status.txt" ]; then
        bandwidth=$(sed -n '1p' /network_status.txt)
        latency=$(sed -n '2p' /network_status.txt)
        echo "Checking current network conditions..."
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
    determine_key_combinations "$bandwidth_int" "$latency_int"

    echo "The current network condition has changed, the security level should change, reselected the keys"
    echo "Selected Keys: $key_type1_str (Traditional), $key_type2_str (PQC)"
}

determine_key_combinations() {
    local bandwidth_int=$1
    local latency_int=$2

    if [ "$bandwidth_int" -lt 50 ] && [ "$latency_int" -gt 100 ]; then
        key_type1_str="KEY_ED25519"
        key_type2_str="KEY_FALCON_512"
    elif [ "$bandwidth_int" -ge 50 ] && [ "$bandwidth_int" -le 150 ] && [ "$latency_int" -ge 50 ] && [ "$latency_int" -le 100 ]; then
        key_type1_str="KEY_RSA_2048"
        key_type2_str="KEY_DILITHIUM_3"
    elif [ "$bandwidth_int" -gt 150 ] && [ "$latency_int" -lt 50 ]; then
        key_type1_str="KEY_ECDSA_256"
        key_type2_str="KEY_FALCON_1024"
    else
        key_type1_str="KEY_RSA_2048"
        key_type2_str="KEY_FALCON_512"
    fi
}

apply_network_conditions_and_establish_connection() {
    local bandwidth_limit=$1
    local latency_limit=$2
    local scenario=$3

    # Remove existing tc qdisc settings
    tc qdisc del dev eth0 root 2>/dev/null

    # Apply the new network conditions using tc
    tc qdisc add dev eth0 root netem rate $bandwidth_limit delay $latency_limit

    # Wait for network changes to take effect
    sleep 5

    # Read actual values from network_status.txt
    if [ -f "/network_status.txt" ]; then
        bandwidth=$(sed -n '1p' /network_status.txt)
        latency=$(sed -n '2p' /network_status.txt)
        echo "Checking current network conditions..."
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
    determine_key_combinations "$bandwidth_int" "$latency_int"

    echo "Selected Keys: $key_type1_str (Traditional), $key_type2_str (PQC)"

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
    echo "******** SOCRATES WP5 - Quantum Safe Hydrid VPN - Testing ******** "
}

while true; do
    echo "Choose an option:"
    echo "1. Establish connection from VPN client to VPN server. (Security Level 1)"
    echo "2. Establish connection from VPN client to VPN server. (Security Level 3)"
    echo "3. Establish connection from VPN client to VPN server. (Security Level 5)"
    echo "4. Establish connection from VPN client to VPN server with mobility. (Mobility between Levels 1, 3, and 5)"
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

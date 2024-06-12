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
            echo "* SOCRATES WP5 - Scenario 1: Low Bandwidth, High Latency *"
            echo "*****************************************"
            bandwidth_limit="30mbit"
            latency_limit="130ms"
            apply_network_conditions_and_establish_connection "$bandwidth_limit" "$latency_limit" $scenario
            ;;
        2)
            echo "*****************************************"
            echo "* SOCRATES WP5 - Scenario 2: Moderate Bandwidth, Moderate Latency *"
            echo "*****************************************"
            bandwidth_limit="50mbit"
            latency_limit="85ms"
            apply_network_conditions_and_establish_connection "$bandwidth_limit" "$latency_limit" $scenario
            ;;
        3)
            echo "*****************************************"
            echo "* SOCRATES WP5 - Scenario 3: High Bandwidth, Moderate Latency *"
            echo "*****************************************"
            bandwidth_limit="85mbit"
            latency_limit="75ms"
            apply_network_conditions_and_establish_connection "$bandwidth_limit" "$latency_limit" $scenario
            ;;
        4)
            echo "*****************************************"
            echo "* SOCRATES WP5 - Scenario 4: Very High Bandwidth, Low Latency *"
            echo "*****************************************"
            bandwidth_limit="150mbit"
            latency_limit="10ms"
            apply_network_conditions_and_establish_connection "$bandwidth_limit" "$latency_limit" $scenario
            ;;
        5)
            echo "*****************************************"
            echo "* SOCRATES WP5 - Scenario 5: Mobility with Changing Network Conditions *"
            echo "*****************************************"
            # Start with condition A
            change_network_conditions "30mbit" "130ms"
            sleep 5
            # Change to condition B
            change_network_conditions1 "150mbit" "10ms"
            sleep 5
            # Change to condition C
            change_network_conditions1 "50mbit" "85ms"
            sleep 5
            return
            ;;
        *)
            echo "Invalid scenario"
            exit 1
            ;;
    esac

    apply_network_conditions_and_establish_connection "$bandwidth_limit" "$latency_limit"
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
}

change_network_conditions1() {
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
}

apply_network_conditions_and_establish_connection() {
    local bandwidth_limit=$1
    local latency_limit=$2

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
}

while true; do
    echo "Choose an option:"
    echo "1. Establish connection from VPN client to VPN server. (scenario 1)"
    echo "2. Establish connection from VPN client to VPN server. (scenario 2)"
    echo "3. Establish connection from VPN client to VPN server. (scenario 3)"
    echo "4. Establish connection from VPN client to VPN server. (scenario 4)"
    echo "5. Establish connection from VPN client to VPN server with mobility. (scenario 5)"
    echo "6. End"
    read -p "Choose: " choice

    case $choice in
        1|2|3|4|5)
            establish_connection $choice
            ;;
        6)
            echo "Ending script."
            exit 0
            ;;
        *)
            echo "Invalid option, please choose again."
            ;;
    esac
done

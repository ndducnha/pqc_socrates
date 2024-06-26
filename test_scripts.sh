#!/bin/bash

echo "Socrates WP5: Network Simulation Script"

# --- Simple condition setting ---
echo "0.1 No network condition setting"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID


echo "0.2 Simulating latency 500ms"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 500ms
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "0.3 Simulating latency 1s"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 1000ms
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID


# --- 5G Network Simulation Scenarios ---

echo "1.1 Simulating High-Speed Urban Area"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 10ms loss 0.1% rate 100mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "1.2 Simulating Medium-Speed Suburban Area"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 20ms loss 0.3% rate 50mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "1.3 Simulating Low-Speed Rural Area"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 30ms loss 0.5% rate 20mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

# --- High Traffic Website Simulation Scenarios ---

echo "2.1 Simulating Normal Website Traffic"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 50ms loss 0.1% rate 100mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "2.2 Simulating Traffic During Sale"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 100ms loss 1% rate 50mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "2.3 Simulating Traffic Spike for Global Launch"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 150ms loss 2% rate 30mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID


# VoIP and Video Conferencing Simulation
echo "3.1 Optimal Conditions for VoIP/Video"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 20ms loss 0.1% rate 10mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "3.2 Average Home Internet for VoIP/Video"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 50ms loss 1% rate 5mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "3.3 Poor Conditions for VoIP/Video"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 100ms loss 2.5% rate 1mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID



# --- Online Gaming Simulation Scenarios ---

echo "4.1 Simulating Local Multiplayer Gaming"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 30ms loss 0.2% rate 20mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "4.2 Simulating International Multiplayer Gaming"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 100ms loss 0.5% rate 10mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "4.3 Simulating Mobile Gaming on 4G"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 75ms loss 1% rate 5mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

# --- Cloud Services Simulation Scenarios ---

echo "5.1 Simulating Cloud Data Transfer - High Bandwidth"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 10ms loss 0.1% rate 100mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "5.2 Simulating Average Cloud Computing Conditions"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 50ms loss 0.5% rate 50mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "5.3 Simulating Cloud Gaming in Distributed Services"
echo "charon has been started."
# Start charon in the background without terminal output
./charon > /dev/null 2>&1 &
# Get the PID of charon
CHARON_PID=$!
sleep 5

tc qdisc add dev eth0 root netem delay 70ms loss 1% rate 20mbit
sleep 1
time bash -c 'swanctl --initiate --child net > /dev/null; swanctl --initiate --child host > /dev/null'
sleep 2
swanctl --terminate --child host > /dev/null
sleep 1
swanctl --terminate --child net > /dev/null
sleep 2
tc qdisc del dev eth0 root

# Terminate charon
kill $CHARON_PID
echo "charon has been terminated."

# Wait for charon to fully terminate
wait $CHARON_PID

echo "All Network Condition Simulations Completed."

import socket
import time
import subprocess

BUFFER_SIZE = 1024
PORT = 12345
OUTPUT_FILE = "network_status.txt"
SECURITY_LEVEL = 5

def measure_bandwidth_server(client_socket):
    total_bytes = 0
    start_time = time.time()

    while True:
        data = client_socket.recv(BUFFER_SIZE)
        if not data:
            break
        total_bytes += len(data)

    end_time = time.time()
    transfer_time = end_time - start_time
    bandwidth_mbps = (total_bytes * 8) / (transfer_time * 1000000.0)

    return bandwidth_mbps

def measure_latency(server_ip):
    result = subprocess.run(['ping', '-c', '10', server_ip], stdout=subprocess.PIPE, text=True)
    for line in result.stdout.split('\n'):
        if 'rtt min/avg/max/mdev' in line:
            latency = line.split('/')[4]
            return float(latency)
    return None

def start_bandwidth_server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('', PORT))
    server_socket.listen(1)
    security_level = SECURITY_LEVEL

    while True:
        client_socket, addr = server_socket.accept()
        bandwidth = measure_bandwidth_server(client_socket)
        client_socket.close()
        
        latency = measure_latency(addr[0])
        if latency is None:
            latency = -1

        print(f"Parsed bandwidth: {bandwidth:.3f} Mbps")
        print(f"Parsed latency: {latency:.3f} ms")

        with open(OUTPUT_FILE, "w") as f:
            f.write(f"{security_level}\n{bandwidth:.3f}\n{latency:.3f}\n")

    server_socket.close()

if __name__ == "__main__":
    start_bandwidth_server()

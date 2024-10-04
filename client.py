import socket
import os
import subprocess
import tempfile
import time

BUFFER_SIZE = 1024
PORT = 12345
OUTPUT_FILE = "network_status.txt"
SERVER_IP = "192.168.0.2"
FILE_SIZE_MB = 10  # Size of the temporary file to be generated
SECURITY_LEVEL = 5

def send_data(server_ip, file_path):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.connect((server_ip, PORT))

    total_bytes = 0
    start_time = time.time()

    with open(file_path, 'rb') as file:
        while (chunk := file.read(BUFFER_SIZE)):
            server_socket.sendall(chunk)
            total_bytes += len(chunk)

    end_time = time.time()
    transfer_time = end_time - start_time
    bandwidth_mbps = (total_bytes * 8) / (transfer_time * 1000000.0)

    server_socket.close()

    return bandwidth_mbps

def measure_latency(server_ip):
    result = subprocess.run(['ping', '-c', '10', server_ip], stdout=subprocess.PIPE, text=True)
    for line in result.stdout.split('\n'):
        if 'rtt min/avg/max/mdev' in line:
            latency = line.split('/')[4]
            return float(latency)
    return None

if __name__ == "__main__":
    temp_file = tempfile.NamedTemporaryFile(delete=False)
    
    try:
        # Generate a temporary file of the specified size
        with open(temp_file.name, 'wb') as f:
            f.write(os.urandom(FILE_SIZE_MB * 1024 * 1024))
        
        while True:
            latency = measure_latency(SERVER_IP)
            if latency is not None:
                print(f"Latency: {latency:.3f} ms")
            else:
                print("Failed to measure latency")
                latency = -1

            bandwidth = send_data(SERVER_IP, temp_file.name)
            print(f"Bandwidth: {bandwidth:.3f} Mbps")

            security_level = SECURITY_LEVEL

            with open(OUTPUT_FILE, "w") as f:
                f.write(f"{security_level}\n{bandwidth:.3f}\n{latency:.3f}\n")

            time.sleep(2)
    finally:
        os.remove(temp_file.name)

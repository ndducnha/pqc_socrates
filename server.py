import socket
import time

BUFFER_SIZE = 1024
PORT = 12345

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

def start_bandwidth_server():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('', PORT))
    server_socket.listen(1)

    while True:
        client_socket, addr = server_socket.accept()
        measure_bandwidth_server(client_socket)
        client_socket.close()

    server_socket.close()

if __name__ == "__main__":
    start_bandwidth_server()

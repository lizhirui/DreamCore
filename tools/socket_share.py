import socket
import queue
import threading
import os

dest_ip = "192.168.0.187"
dest_port = 10250
src_port = 10250

send_queue = queue.Queue()
client_list = []

def client_worker(socket):
    try:
        while True:
            data = socket.recv(1024)
            
            if not data:
                break

            for client in client_list:
                try:
                    client.send(data)
                except:
                    pass
    except:
        pass

    try:
        socket.close()
    except:
        pass

    os._exit(0)

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client_socket.connect((dest_ip, dest_port))
t = threading.Thread(target=client_worker, args=(client_socket,))
t.start()

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server_socket.bind(("0.0.0.0", src_port))
server_socket.listen(10)

def worker(client):
    client_list.append(client)

    try:
        while True:
            data = client.recv(1024)
            
            if not data:
                break

            send_queue.put(data)
    except:
        pass

    try:
        client.close()
    except:
        pass
    
    client_list.remove(client)

def server_worker():
    try:
        while True:
            data = send_queue.get()
            client_socket.send(data)
    except:
        pass

    try:
        client_socket.close()
    except:
        pass

    os._exit(0)

while True:
    conn, addr = server_socket.accept()
    print("Connected by", addr)
    t_client = threading.Thread(target=worker, args=(conn, ))
    t_client.start()
    t_server = threading.Thread(target=server_worker)
    t_server.start()
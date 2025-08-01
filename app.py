from flask import Flask, request
import socket

app = Flask(__name__)

@app.route('/')
def hello():
    ip_address = request.remote_addr
    hostname = socket.gethostname()
    pod_ip = socket.gethostbyname(hostname)
    return f"Hello from pod with IP: {pod_ip}\nClient IP: {ip_address}", 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)

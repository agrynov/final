from flask import Flask, request, jsonify
import socket
import os
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def hello():
    """Main endpoint that returns pod information and client details"""
    try:
        # Get pod information
        hostname = socket.gethostname()
        pod_ip = socket.gethostbyname(hostname)
        client_ip = request.remote_addr
        
        # Get additional environment information
        node_name = os.environ.get('NODE_NAME', 'unknown')
        pod_name = os.environ.get('POD_NAME', hostname)
        namespace = os.environ.get('POD_NAMESPACE', 'default')
        
        response_data = {
            "message": "Hello from Flask application!",
            "timestamp": datetime.utcnow().isoformat(),
            "pod_info": {
                "pod_ip": pod_ip,
                "pod_name": pod_name,
                "hostname": hostname,
                "namespace": namespace,
                "node_name": node_name
            },
            "client_info": {
                "client_ip": client_ip,
                "user_agent": request.headers.get('User-Agent', 'unknown')
            },
            "status": "healthy"
        }
        
        return jsonify(response_data), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({"status": "healthy", "timestamp": datetime.utcnow().isoformat()}), 200

@app.route('/ready')
def ready():
    """Readiness check endpoint"""
    return jsonify({"status": "ready", "timestamp": datetime.utcnow().isoformat()}), 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port, debug=False)

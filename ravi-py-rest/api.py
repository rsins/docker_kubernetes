#!/usr/bin/env python

import flask
from flask import request, jsonify
import platform,socket,re,uuid,psutil,logging

app = flask.Flask(__name__)

def getSystemInfo():
    try:
        info={}
        info['platform']=platform.system()
        info['platform-release']=platform.release()
        info['platform-version']=platform.version()
        info['architecture']=platform.machine()
        info['hostname']=socket.gethostname()
        info['ip-address']=socket.gethostbyname(socket.gethostname())
        info['mac-address']=':'.join(re.findall('..', '%012x' % uuid.getnode()))
        info['processor']=platform.processor()
        info['ram']=str(round(psutil.virtual_memory().total / (1024.0 **3)))+" GB"
        return info
    except Exception as e:
        logging.exception(e)

@app.route('/', methods=['GET'])
def home():
    return '''
             <h1> Trial App using Python Flask <h1>
             <p>Try to call rest api /api/v1/system/info </p>
           '''

@app.route('/api/v1/system/info', methods=['GET'])
def api_system_info():
    return jsonify(getSystemInfo())

app.run(host='0.0.0.0', port=5050)


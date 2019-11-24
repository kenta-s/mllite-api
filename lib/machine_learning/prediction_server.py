from flask import Flask, escape, request, jsonify
from os import environ, path
import tensorflow as tf
from tensorflow import keras
import numpy as np
from IPython import embed
from myLiblary import json_to_np_array
import json

identifier = environ.get("IDENTIFIER")
model_path = path.join(path.dirname(__file__), 'tmp/{identifier}.h5'.format(identifier=identifier))
model = keras.models.load_model(model_path)

app = Flask(__name__)

@app.route('/')
def hello():
    name = request.args.get("name", "World")
    return f'Hello, {escape(name)}!'

@app.route('/prediction/<identifier>', methods=['POST'])
def post(identifier):
    body = request.get_data()
    json_string = body.decode('utf8').replace("'",'"')
    res = json.loads(json_string)
    print(res)
    d = np.array([json_to_np_array(identifier, res)])
    res = model.predict(d)
    result = {
      "result": int(np.argmax(res))
    }
    return jsonify(result)

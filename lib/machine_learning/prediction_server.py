from flask import Flask, escape, request, jsonify
from os import environ, path
import tensorflow as tf
import pandas as pd
import numpy as np
from IPython import embed
import MeCab
from gensim import corpora, matutils
from sklearn.model_selection import train_test_split
from tensorflow import keras
from myLiblary import text_to_np_array

model = keras.models.load_model(environ.get("MODEL_PATH"))
# model = keras.models.load_model('model.h5')

app = Flask(__name__)

print(environ.get("MODEL_PATH"))
df = pd.read_csv(environ.get("CSV_PATH"))
# df = pd.read_csv('./ready.csv')
@app.route('/')
def hello():
    name = request.args.get("name", "World")
    return f'Hello, {escape(name)}!'

import json
@app.route('/prediction/<identifier>', methods=['POST'])
def post(identifier):
    body = request.get_data()
    json_string = body.decode('utf8').replace("'",'"')
    res = json.loads(json_string)
    print(res)
    t = res["text"]
    # t = "Xperiaはとても良いですね"
    d = np.array([text_to_np_array(df, t)])
    res = model.predict(d)
    result = {
      "result": int(np.argmax(res))
    }
    return jsonify(result)

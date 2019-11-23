import tensorflow as tf
import pandas as pd
import numpy as np
from IPython import embed
import MeCab
from gensim import corpora, matutils
from sklearn.model_selection import train_test_split

from myLiblary import get_dictionary, prepare_train_variables

df = pd.read_csv('./tmp/ready.csv')
TEST_SIZE = 0.1

train, test = train_test_split(df, test_size=0.1)
x_train, y_train = prepare_train_variables(df, train[['text', 'y']])
x_test, y_test = prepare_train_variables(df, test[['text', 'y']])

model = tf.keras.models.Sequential()
# model.add(tf.keras.layers.Flatten(input_shape=...))
# model.add(tf.keras.layers.Dense(64, input_shape=(x_train.shape[1],), activation=tf.nn.relu))
model.add(tf.keras.layers.Dense(64, activation=tf.nn.relu))
model.add(tf.keras.layers.Dropout(0.5))
model.add(tf.keras.layers.Dense(64, activation=tf.nn.relu))
model.add(tf.keras.layers.Dropout(0.5))
model.add(tf.keras.layers.Dense(64, activation=tf.nn.relu))
model.add(tf.keras.layers.Dense(3, activation=tf.nn.softmax))

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])

model.fit(x_train, y_train, epochs=10)
test_loss, test_acc = model.evaluate(x_test, y_test)
print('\nTest accuracy:', test_acc)
model.save('./tmp/model.h5')

# tf.keras.models.save_model(
#     model,
#     './model.h5',
# )

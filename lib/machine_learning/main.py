from sys import argv
from os import path
import tensorflow as tf
import pandas as pd

from myLiblary import prepare_train_variables

csv_path = argv[1]
identifier = argv[2]

df = pd.read_csv(csv_path)
TEST_SIZE = 0.1

train = df.sample(frac=0.9,random_state=0)
test = df.drop(train.index)

x_train, y_train = prepare_train_variables(df, train[['text', 'y']])
x_test, y_test = prepare_train_variables(df, test[['text', 'y']])

model = tf.keras.models.Sequential()
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
pathname = path.join(path.dirname(__file__), 'tmp/{identifier}.h5'.format(identifier=identifier))
model.save(pathname)

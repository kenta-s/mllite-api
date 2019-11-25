#
# xgboost
# sklearn

from sys import argv
from os import path
import pandas as pd
from myLiblary import prepare_train_variables
from sklearn.metrics import accuracy_score
import xgboost as xgb

identifier = argv[1]
csv_path = path.join(path.dirname(__file__), 'tmp/{identifier}.csv'.format(identifier=identifier))

df = pd.read_csv(csv_path)

train = df.sample(frac=0.9,random_state=0)
test = df.drop(train.index)
x_train, y_train = prepare_train_variables(identifier, df, train)
x_test, y_test = prepare_train_variables(identifier, df, test)

X = x_train
y = y_train

xgb_model = xgb.XGBClassifier(objective="multi:softprob", random_state=42)
xgb_model.fit(x_train, y_train)

y_pred = xgb_model.predict(x_test)
acc = accuracy_score(y_test, y_pred)
print('Accuracy:', acc)

# README

## train model

```
$ python3 main.py {identifier}
```

## run prediction server

```
FLASK_RUN_PORT=6000 FLASK_APP=prediction_server.py IDENTIFIER={identifier} flask run --host=0.0.0.0
```

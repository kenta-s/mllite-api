from sys import argv
from os import path
import MeCab
from gensim import corpora, matutils
import numpy as np

mecab = MeCab.Tagger ("-Ochasen")
mecab.parse('')

def extract_words(text):
    # target = ["名詞","動詞","助詞","形容詞"]
    target = ["名詞","動詞","形容詞"]
    node = mecab.parseToNode(text)
    words = []
    while node:
        meta = node.feature.split(",")
        if meta[0] in target:
            words.append(node.surface)
        node = node.next
    return words

def convert_text_into_dense(dictionary, text):
    words = extract_words(text)
    vec = dictionary.doc2bow(words)
    dense = list(matutils.corpus2dense([vec], num_terms=len(dictionary)).T[0])
    return dense

def convert_text_into_np_array(dictionary, text):
    dense = convert_text_into_dense(dictionary, text)
    return np.array(dense)

def get_dictionary(identifier, csv):
    # argv[1] is occupied by csv path
    dictionary_name = path.join(path.dirname(__file__), 'tmp/{identifier}.txt'.format(identifier=identifier))
    # dictionary_name = path.join(path.dirname(__file__), 'tmp/{identifier}.txt'.format(identifier='d46927ab-cda6-47a6-92a6-3d50d399410c'))

    words = []
    for text in csv['text']:
          words.append(extract_words(text))

    dictionary = corpora.Dictionary(words)
    # dictionary.save_as_text(dictionary_name)
    dictionary.save(dictionary_name)

    return dictionary

def prepare_train_variables(identifier, df, csv):
    dictionary = get_dictionary(identifier, df)
    x_list = []
    y_list = []
    for _, row in csv.iterrows():
        # TODO: use all parameters
        text = row[0]
        dense = convert_text_into_np_array(dictionary, text)
        y_list.append(np.array([row['y']]))
        tmp = np.array([dense])
        x_list.append(dense)

    return np.array(x_list), np.array(y_list)

def json_to_np_array(identifier, json):
    dictionary_name = path.join(path.dirname(__file__), 'tmp/{identifier}.txt'.format(identifier=identifier))
    dictionary = corpora.Dictionary.load(dictionary_name)
    # TODO: handle all json
    text = json['text']
    dense = convert_text_into_dense(dictionary, text)
    return np.array(dense)

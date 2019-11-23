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

def get_dictionary(csv):
    dictionary_name = './tmp/words.txt'
    words = []
    for text in csv['text']:
          words.append(extract_words(text))

    dictionary = corpora.Dictionary(words)
    dictionary.save_as_text(dictionary_name)

    return dictionary

def prepare_train_variables(df, csv):
    dictionary = get_dictionary(df)
    x_list = []
    y_list = []
    for _, row in csv.iterrows():
        text = row[0]
        dense = convert_text_into_np_array(dictionary, text)
        y_list.append(np.array([row[1]]))
        tmp = np.array([dense])
        x_list.append(dense)

    return np.array(x_list), np.array(y_list)

def text_to_np_array(df, text):
    dictionary = get_dictionary(df)
    dense = convert_text_into_dense(dictionary, text)
    return np.array(dense)

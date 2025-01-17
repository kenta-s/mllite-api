class MlModelTrainingJob < ApplicationJob
  queue_as :training

  def perform(ml_model_id:)
    ml_model = MlModel.find(ml_model_id)
    ml_model.training!

    bucket = MlLiteBucket.new
		obj = bucket.object("csv/#{ml_model.identifier}.csv")
    csv_path = Rails.root.join('lib', 'machine_learning', 'tmp', "#{ml_model.identifier}.csv")
		obj.get(response_target: csv_path)
    stdout = `python3 #{Rails.root.join('lib','machine_learning', 'main.py')} #{csv_path} #{ml_model.identifier}`
    h5_filepath = Rails.root.join('lib','machine_learning', 'tmp', "#{ml_model.identifier}.h5")
    h5_obj = bucket.object("models/#{ml_model.identifier}.h5")
    File.open(h5_filepath) do |f|
      h5_obj.put(body: f)
    end
		# TODO: up server
    ml_model.ready!

# stdout is like this

# Epoch 1/10
# 14391/14391 [==============================] - 2s 168us/sample - loss: 0.7690 - acc: 0.6760
# Epoch 2/10
# 14391/14391 [==============================] - 2s 152us/sample - loss: 0.4693 - acc: 0.8290
# Epoch 3/10
# 14391/14391 [==============================] - 2s 146us/sample - loss: 0.3391 - acc: 0.8802
# Epoch 4/10
# 14391/14391 [==============================] - 2s 148us/sample - loss: 0.2521 - acc: 0.9109
# Epoch 5/10
# 14391/14391 [==============================] - 2s 150us/sample - loss: 0.1966 - acc: 0.9308
# Epoch 6/10
# 14391/14391 [==============================] - 2s 148us/sample - loss: 0.1695 - acc: 0.9399
# Epoch 7/10
# 14391/14391 [==============================] - 2s 148us/sample - loss: 0.1364 - acc: 0.9517
# Epoch 8/10
# 14391/14391 [==============================] - 2s 150us/sample - loss: 0.1146 - acc: 0.9614
# Epoch 9/10
# 14391/14391 [==============================] - 2s 143us/sample - loss: 0.1090 - acc: 0.9628
# Epoch 10/10
# 14391/14391 [==============================] - 2s 145us/sample - loss: 0.1000 - acc: 0.9667
# 1599/1599 [==============================] - 0s 63us/sample - loss: 0.8970 - acc: 0.7817
#
# Test accuracy: 0.7817386

  end
end

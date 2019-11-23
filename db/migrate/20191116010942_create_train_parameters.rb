class CreateTrainParameters < ActiveRecord::Migration[6.0]
  def change
    create_table :train_parameters do |t|
      t.references :ml_model, null: false, foreign_key: true
      t.string :name, null: false

      t.timestamps
    end
  end
end

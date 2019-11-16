class CreateTrainData < ActiveRecord::Migration[6.0]
  def change
    create_table :train_data do |t|
      t.references :ml_model, null: false, foreign_key: true
      t.string :y, null: false

      t.timestamps
    end
  end
end

class CreateMlModels < ActiveRecord::Migration[6.0]
  def change
    create_table :ml_models do |t|
      t.string :identifier, null: false
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :status, null: false, default: 0

      t.timestamps
    end

    add_index :ml_models, :identifier, unique: true
  end
end

class TrainParameter < ApplicationRecord
  belongs_to :ml_model
  # belongs_to :train_datum

  validates :name, presence: true, length: { maximum: 32 }
  # validates :value, presence: true, length: { maximum: 1000 }
end

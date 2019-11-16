class TrainDatum < ApplicationRecord
  belongs_to :ml_model

  validates :y, presence: true, length: { maximum: 32 }
end

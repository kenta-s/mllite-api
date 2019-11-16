class TrainDatum < ApplicationRecord
  belongs_to :ml_model
  has_many :train_parameters, dependent: :destroy

  validates :y, presence: true, length: { maximum: 32 }
end

class MlModel < ApplicationRecord
  has_one_attached :csv
  belongs_to :user

  enum status: {
    no_data: 0,
    pending: 1,
    training: 2,
    ready: 3,
    error: 4,
  }

  has_many :train_data, dependent: :destroy

  validates :name, presence: true, length: { maximum: 32 }
end

class MlModel < ApplicationRecord
  belongs_to :user

  enum status: {
    no_data: 0,
    pending: 1,
    training: 2,
    ready: 3,
  }

  has_many :train_data, dependent: :destroy

  validates :name, presence: true, length: { maximum: 32 }
end

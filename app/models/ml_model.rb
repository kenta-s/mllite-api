class MlModel < ApplicationRecord
  # has_one_attached :csv
  # has_one_attached :trained_model
  belongs_to :user

  enum status: {
    no_data: 0,
    pending: 1,
    training: 2,
    ready: 3,
    error: 4,
  }

  has_many :train_parameters, dependent: :destroy
  # has_many :train_data, dependent: :destroy

  validates :name, presence: true, length: { maximum: 32 }
  before_create :set_identifier

  private

  # identifier is not validated in Application level but it has constraints in DB level
  def set_identifier
    self.identifier ||= SecureRandom.uuid
  end
end

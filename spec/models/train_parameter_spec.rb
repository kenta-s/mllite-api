require 'rails_helper'

RSpec.describe TrainParameter, type: :model do
  describe "associations" do
    it { should belong_to(:ml_model) }
    # it { should belong_to(:train_datum) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(32) }
    # it { should validate_presence_of(:value) }
    # it { should validate_length_of(:value).is_at_most(1000) }
  end
end

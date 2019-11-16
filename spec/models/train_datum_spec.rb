require 'rails_helper'

RSpec.describe TrainDatum, type: :model do
  describe "associations" do
    it { should belong_to(:ml_model) }
    it { should have_many(:train_parameters).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:y) }
    it { should validate_length_of(:y).is_at_most(32) }
  end
end

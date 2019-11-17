require 'rails_helper'

RSpec.describe MlModel, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:train_parameters).dependent(:destroy) }
    # it { should have_many(:train_data).dependent(:destroy) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(32) }
  end
end

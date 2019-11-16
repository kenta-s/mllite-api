require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:ml_models).dependent(:destroy) }
  end
end

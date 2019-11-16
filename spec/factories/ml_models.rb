FactoryBot.define do
  factory :ml_model do
    user { nil }
    name { "MyString" }
    status { 1 }
    trait :ready do
      status { :ready }
      after(:build) do |ml_model|
        ml_model.train_data << FactoryBot.create(:train_datum, :with_2_parameters, ml_model: ml_model)
      end
    end
  end
end

FactoryBot.define do
  factory :ml_model do
    # sequence :identifier do |n|
    #   "abcdefg#{n}"
    # end
    user { nil }
    name { "MyString" }
    status { 1 }
    trait :ready do
      status { :ready }
      after(:build) do |ml_model|
        ml_model.train_parameters << FactoryBot.create(:train_parameter, ml_model: ml_model, name: 'news_content')
        ml_model.train_parameters << FactoryBot.create(:train_parameter, ml_model: ml_model, name: 'media_name')
      end
      # after(:build) do |ml_model|
      #   ml_model.train_data << FactoryBot.create(:train_datum, :with_2_parameters, ml_model: ml_model)
      # end
    end
  end
end

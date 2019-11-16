FactoryBot.define do
  factory :train_datum do
    ml_model { nil }
    y { "entertainment" }

    trait :with_2_parameters do
      y { "entertainment" }
      after(:create) do |train_datum|
        train_datum.train_parameters << FactoryBot.create(:train_parameter, train_datum: train_datum, name: 'news_content', value: 'Johnny Depp got married')
        train_datum.train_parameters << FactoryBot.create(:train_parameter, train_datum: train_datum, name: 'media_name', value: 'Haff Post')
      end
    end
  end
end

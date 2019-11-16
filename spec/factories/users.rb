FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "foo#{n}@example.com"
    end
    password { 'abcdefg1' }
    confirmed_at { Time.zone.local(2019, 9, 1, 10, 30) }
  end
end

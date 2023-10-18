FactoryBot.define do
  factory :user do
    name { 'test_user' }
    sequence :email do |n|
      "test_user#{n}@example.com"
    end
    password { 'password' }
    password_confirmation { 'password' }
  end
end

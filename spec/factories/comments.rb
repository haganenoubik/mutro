FactoryBot.define do
  factory :comment do
    user { nil }
    playlist { nil }
    content { 'MyText' }
  end
end

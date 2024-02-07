FactoryBot.define do
  factory :order_shipping_address do
    post_code { "#{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 4)}" }
    prefecture_id { Faker::Number.between(from: 1, to: 47) }
    city { Faker::Address.city }
    address { Faker::Address.street_address }
    building { Faker::Address.secondary_address }
    phone_number { Faker::Number.leading_zero_number(digits: rand(10..11)) }
    token { "tok_#{Faker::Alphanumeric.alpha(number: 28)}" }
  end
end
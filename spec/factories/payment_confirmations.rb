FactoryBot.define do
  factory :payment_confirmation do
    association :game_bundle
    association :player
    amount { 100 }
  end
end

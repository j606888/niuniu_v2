FactoryBot.define do
  factory :payment_confirmation do
    game_bundle { nil }
    player { nil }
    amount { 1 }
    is_confirmed { false }
  end
end

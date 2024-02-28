FactoryBot.define do
  factory :game do
    association :dealer, factory: :player
    association :line_group
    max_bet_amount { 200 }
  end
end

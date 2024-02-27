FactoryBot.define do
  factory :bet_record do
    association :player
    association :game
  end
end

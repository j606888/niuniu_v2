FactoryBot.define do
  factory :player do
    association :line_group
    sequence(:name) { |i| "player#{i}" }
    sequence(:line_user_id) { |i| "line_user_id#{i}" }
  end
end

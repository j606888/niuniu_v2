FactoryBot.define do
  factory :line_group do
    sequence(:name) { |i| "line_group#{i}" }
    sequence(:group_id) { |i| "group_id#{i}" }
  end
end

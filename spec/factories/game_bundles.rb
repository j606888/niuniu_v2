FactoryBot.define do
  factory :game_bundle do
    association :line_group
    aasm_state { "created" }
  end
end

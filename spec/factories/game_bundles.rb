FactoryBot.define do
  factory :game_bundle do
    line_group { nil }
    aasm_state { "MyString" }
  end
end

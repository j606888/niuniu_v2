# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_02_27_132610) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bet_records", force: :cascade do |t|
    t.bigint "game_id", null: false
    t.bigint "player_id", null: false
    t.integer "bet_amount"
    t.json "cards"
    t.integer "win_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_bet_records_on_game_id"
    t.index ["player_id"], name: "index_bet_records_on_player_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "line_group_id", null: false
    t.string "aasm_state", null: false
    t.integer "max_bet_amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_group_id"], name: "index_games_on_line_group_id"
  end

  create_table "line_groups", force: :cascade do |t|
    t.string "name"
    t.string "group_id"
    t.string "room_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.string "line_user_id"
    t.bigint "line_group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["line_group_id"], name: "index_players_on_line_group_id"
  end

  add_foreign_key "bet_records", "games"
  add_foreign_key "bet_records", "players"
  add_foreign_key "games", "line_groups"
  add_foreign_key "players", "line_groups"
end

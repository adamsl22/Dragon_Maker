# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_31_083516) do

  create_table "dragons", force: :cascade do |t|
    t.string "name"
    t.string "wing_span"
    t.string "color"
    t.string "pattern"
    t.integer "hunger"
    t.string "health"
    t.integer "game_id"
  end

  create_table "game_data", force: :cascade do |t|
    t.string "player_name"
    t.integer "turn"
    t.integer "eggs"
    t.integer "score"
    t.integer "mpi"
    t.integer "tp"
  end

  create_table "raid_pairings", force: :cascade do |t|
    t.integer "raid_id"
    t.integer "dragon_id"
  end

  create_table "raids", force: :cascade do |t|
    t.integer "village_id"
    t.integer "dice_roll"
    t.integer "game_id"
  end

  create_table "villages", force: :cascade do |t|
    t.string "name"
    t.integer "population"
    t.integer "knights"
    t.integer "slayers"
    t.integer "game_id"
  end

end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190508032007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "conferences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "player_seasons", force: :cascade do |t|
    t.integer "season_type"
    t.integer "year"
    t.string "name"
    t.string "team_name"
    t.string "position"
    t.datetime "updated"
    t.integer "games"
    t.integer "minutes"
    t.integer "field_goals_made"
    t.integer "field_goals_attempted"
    t.decimal "field_goals_percentage"
    t.decimal "effective_field_goals_percentage"
    t.integer "two_pointers_made"
    t.integer "two_pointers_attempted"
    t.decimal "two_pointers_percentage"
    t.integer "three_pointers_made"
    t.integer "three_pointers_attempted"
    t.decimal "three_pointers_percentage"
    t.integer "free_throws_made"
    t.integer "free_throws_attempted"
    t.decimal "free_throws_percentage"
    t.integer "offensive_rebounds"
    t.integer "defensive_rebounds"
    t.integer "rebounds"
    t.decimal "offensive_rebounds_percentage"
    t.decimal "defensive_rebounds_percentage"
    t.decimal "total_rebounds_percentage"
    t.integer "assists"
    t.integer "steals"
    t.integer "blocked_shots"
    t.integer "turnovers"
    t.integer "personal_fouls"
    t.integer "points"
    t.decimal "true_shooting_percentage"
    t.decimal "player_efficiency_rating"
    t.decimal "assists_percentage"
    t.decimal "steals_percentage"
    t.decimal "blocks_percentage"
    t.decimal "turnovers_percentage"
    t.decimal "usage_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_id"
    t.bigint "team_id"
    t.bigint "season_id"
    t.bigint "team_season_id"
    t.index ["player_id"], name: "index_player_seasons_on_player_id"
    t.index ["season_id"], name: "index_player_seasons_on_season_id"
    t.index ["team_id"], name: "index_player_seasons_on_team_id"
    t.index ["team_season_id"], name: "index_player_seasons_on_team_season_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "jersey"
    t.string "position"
    t.string "year"
    t.integer "height"
    t.integer "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.boolean "active"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer "season"
    t.integer "start_year"
    t.integer "end_year"
    t.string "description"
    t.date "regular_season_start_date"
    t.date "regular_season_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["season"], name: "index_seasons_on_season", unique: true
  end

  create_table "stadia", force: :cascade do |t|
    t.string "name"
    t.string "city"
    t.string "state"
    t.string "country"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_seasons", force: :cascade do |t|
    t.integer "season_type"
    t.integer "year"
    t.string "name"
    t.string "team_abbreviation"
    t.integer "wins"
    t.integer "losses"
    t.integer "conference_wins"
    t.integer "conference_losses"
    t.decimal "possessions"
    t.datetime "updated"
    t.integer "games"
    t.integer "minutes"
    t.integer "field_goals_made"
    t.integer "field_goals_attempted"
    t.decimal "field_goals_percentage"
    t.decimal "effective_field_goals_percentage"
    t.integer "two_pointers_made"
    t.decimal "two_pointers_attempted"
    t.integer "three_pointers_made"
    t.integer "three_pointers_attempted"
    t.decimal "three_pointers_percentage"
    t.integer "free_throws_made"
    t.integer "free_throws_attempted"
    t.decimal "free_throws_percentage"
    t.integer "offensive_rebounds"
    t.integer "defensive_rebounds"
    t.integer "rebounds"
    t.decimal "offensive_rebounds_percentage"
    t.decimal "defensive_rebounds_percentage"
    t.decimal "total_rebounds_percentage"
    t.integer "assists"
    t.integer "steals"
    t.integer "blocked_shots"
    t.integer "turnovers"
    t.integer "personal_fouls"
    t.integer "points"
    t.decimal "true_shooting_percentage"
    t.decimal "assists_percentage"
    t.decimal "steals_percentage"
    t.decimal "blocks_percentage"
    t.decimal "turnovers_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.bigint "season_id"
    t.decimal "two_pointers_percentage"
    t.index ["season_id"], name: "index_team_seasons_on_season_id"
    t.index ["team_id"], name: "index_team_seasons_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "school"
    t.string "name"
    t.integer "ap_rank"
    t.integer "wins"
    t.integer "losses"
    t.integer "conference_wins"
    t.integer "conference_losses"
    t.string "team_logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "conference_id"
    t.bigint "stadium_id"
    t.string "short_display_name"
    t.index ["conference_id"], name: "index_teams_on_conference_id"
    t.index ["school"], name: "index_teams_on_school", unique: true
    t.index ["stadium_id"], name: "index_teams_on_stadium_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_name"
    t.string "password_digest"
    t.string "remember_digest"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.boolean "admin", default: false
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "player_seasons", "players"
  add_foreign_key "player_seasons", "seasons"
  add_foreign_key "player_seasons", "team_seasons"
  add_foreign_key "player_seasons", "teams"
  add_foreign_key "players", "teams"
  add_foreign_key "team_seasons", "seasons"
  add_foreign_key "team_seasons", "teams"
  add_foreign_key "teams", "conferences"
  add_foreign_key "teams", "stadia"
end

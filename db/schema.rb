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

ActiveRecord::Schema.define(version: 20200302190235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blog_posts", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.text "preview"
    t.text "body"
    t.string "image_url"
    t.date "date"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published", default: false
    t.bigint "user_id"
    t.string "url_path"
    t.index ["team_id"], name: "index_blog_posts_on_team_id"
    t.index ["url_path"], name: "index_blog_posts_on_url_path", unique: true
    t.index ["user_id"], name: "index_blog_posts_on_user_id"
  end

  create_table "bracketologies", force: :cascade do |t|
    t.string "tournament_field"
    t.string "conference_winners"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_four_byes"
    t.string "last_four_in"
    t.string "first_four_out"
    t.string "next_four_out"
    t.string "round_of_sixtyfour"
    t.string "round_of_thirtytwo"
    t.string "round_of_sixteen"
    t.string "round_of_eight"
    t.string "round_of_four"
    t.string "round_of_two"
    t.integer "champion_id"
  end

  create_table "conferences", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "abbreviation"
    t.boolean "locked", default: false
  end

  create_table "games", force: :cascade do |t|
    t.integer "year"
    t.integer "season_type"
    t.string "status"
    t.date "day"
    t.datetime "date_time"
    t.string "away_team_name"
    t.string "home_team_name"
    t.integer "away_team_score"
    t.integer "home_team_score"
    t.datetime "updated"
    t.decimal "point_spread"
    t.decimal "over_under"
    t.integer "away_team_money_line"
    t.integer "home_team_money_line"
    t.string "bracket"
    t.integer "round"
    t.integer "away_team_seed"
    t.integer "home_team_seed"
    t.integer "away_team_previous_game_id"
    t.integer "home_team_previous_game_id"
    t.integer "tournament_display_order"
    t.string "tournament_display_order_for_home_team"
    t.boolean "is_closed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "season_id"
    t.bigint "stadium_id"
    t.bigint "home_team_id"
    t.bigint "away_team_id"
    t.decimal "possessions"
    t.decimal "home_offensive_efficiency"
    t.decimal "away_offensive_efficiency"
    t.decimal "pace"
    t.boolean "is_completed"
    t.integer "player_of_the_game_id"
    t.boolean "locked", default: false
    t.float "thrill_score"
    t.index ["away_team_id"], name: "index_games_on_away_team_id"
    t.index ["home_team_id"], name: "index_games_on_home_team_id"
    t.index ["player_of_the_game_id"], name: "index_games_on_player_of_the_game_id"
    t.index ["season_id"], name: "index_games_on_season_id"
    t.index ["stadium_id"], name: "index_games_on_stadium_id"
  end

  create_table "player_games", force: :cascade do |t|
    t.integer "season_type"
    t.integer "year"
    t.string "name"
    t.string "team_name"
    t.string "position"
    t.string "injury_status"
    t.string "opponent_name"
    t.date "day"
    t.datetime "date_time"
    t.string "home_or_away"
    t.integer "num_games"
    t.integer "minutes"
    t.integer "field_goals_made"
    t.integer "field_goals_attempted"
    t.decimal "field_goals_percentage"
    t.integer "two_pointers_made"
    t.integer "two_pointers_attempted"
    t.decimal "two_pointers_percentage"
    t.integer "three_pointers_made"
    t.integer "three_pointers_attempted"
    t.decimal "three_pointers_percentage"
    t.integer "free_throws_made"
    t.integer "free_throws_attempted"
    t.integer "free_throws_percentage"
    t.integer "offensive_rebounds"
    t.integer "defensive_rebounds"
    t.integer "rebounds"
    t.integer "assists"
    t.integer "steals"
    t.integer "blocked_shots"
    t.integer "turnovers"
    t.integer "personal_fouls"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.bigint "player_id"
    t.bigint "player_season_id"
    t.bigint "season_id"
    t.bigint "game_id"
    t.bigint "opponent_id"
    t.decimal "bpm"
    t.decimal "offensive_bpm"
    t.decimal "defensive_bpm"
    t.decimal "game_score"
    t.decimal "per"
    t.decimal "offensive_rebounds_percentage"
    t.decimal "defensive_rebounds_percentage"
    t.decimal "rebounds_percentage"
    t.decimal "steals_percentage"
    t.decimal "blocks_percentage"
    t.decimal "assists_percentage"
    t.decimal "usage_rate"
    t.decimal "turnovers_percentage"
    t.decimal "true_shooting_percentage"
    t.decimal "effective_field_goals_percentage"
    t.boolean "qualified"
    t.decimal "prophet_rating"
    t.boolean "locked", default: false
    t.index ["game_id"], name: "index_player_games_on_game_id"
    t.index ["opponent_id"], name: "index_player_games_on_opponent_id"
    t.index ["player_id"], name: "index_player_games_on_player_id"
    t.index ["player_season_id"], name: "index_player_games_on_player_season_id"
    t.index ["season_id"], name: "index_player_games_on_season_id"
    t.index ["team_id"], name: "index_player_games_on_team_id"
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
    t.decimal "bpm"
    t.decimal "offensive_bpm"
    t.decimal "defensive_bpm"
    t.decimal "aper"
    t.decimal "prophet_rating"
    t.decimal "points_per_game"
    t.decimal "rebounds_per_game"
    t.decimal "minutes_per_game"
    t.decimal "minutes_percentage"
    t.decimal "games_percentage"
    t.integer "player_of_the_games"
    t.decimal "assists_per_game"
    t.decimal "steals_per_game"
    t.decimal "blocks_per_game"
    t.boolean "locked", default: false
    t.string "preseason_description"
    t.bigint "conference_id"
    t.index ["conference_id"], name: "index_player_seasons_on_conference_id"
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
    t.boolean "locked", default: false
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "predictions", force: :cascade do |t|
    t.date "day"
    t.integer "home_team_prediction"
    t.integer "away_team_prediction"
    t.integer "home_team_score"
    t.integer "away_team_score"
    t.decimal "point_spread"
    t.decimal "over_under"
    t.decimal "prediction_difference_point_spread"
    t.decimal "prediction_difference_over_under"
    t.decimal "confidence_point_spread"
    t.decimal "confidence_over_under"
    t.decimal "expected_value_point_spread"
    t.decimal "expected_value_over_under"
    t.boolean "home_favorite"
    t.boolean "favorite_favorite"
    t.boolean "pace_favorite"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "game_id"
    t.bigint "season_id"
    t.integer "moneyline"
    t.decimal "prediction_difference_moneyline"
    t.decimal "confidence_moneyline"
    t.decimal "expected_value_moneyline"
    t.boolean "win_point_spread"
    t.boolean "win_over_under"
    t.boolean "win_moneyline"
    t.decimal "winnings_point_spread"
    t.decimal "winnings_over_under"
    t.decimal "winnings_moneyline"
    t.decimal "predicted_point_spread"
    t.decimal "predicted_over_under"
    t.integer "predicted_moneyline"
    t.decimal "home_win_probability"
    t.boolean "win_straight_up"
    t.decimal "confidence_straight_up"
    t.text "description"
    t.decimal "home_advantage"
    t.decimal "defense_advantage"
    t.decimal "assists_advantage"
    t.decimal "three_pointers_advantage"
    t.decimal "pace_advantage"
    t.decimal "injury_advantage"
    t.string "home_moneyline_bet"
    t.string "over_under_bet"
    t.string "best_bet"
    t.decimal "best_bet_value"
    t.boolean "top_play"
    t.index ["game_id"], name: "index_predictions_on_game_id"
    t.index ["season_id"], name: "index_predictions_on_season_id"
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
    t.decimal "adj_offensive_efficiency"
    t.decimal "adj_defensive_efficiency"
    t.decimal "adj_tempo"
    t.decimal "offensive_efficiency"
    t.decimal "defensive_efficiency"
    t.decimal "effective_field_goals_percentage"
    t.decimal "turnovers_percentage"
    t.decimal "free_throws_rate"
    t.decimal "offensive_rebounds_percentage"
    t.decimal "defensive_rebounds_percentage"
    t.decimal "blocks_percentage"
    t.decimal "steals_percentage"
    t.decimal "three_pointers_rate"
    t.decimal "assists_percentage"
    t.decimal "true_shooting_percentage"
    t.date "post_season_end_date"
    t.decimal "aper"
    t.decimal "consistency"
    t.decimal "home_advantage"
    t.decimal "three_pointers_proficiency"
    t.decimal "over_win_pct"
    t.decimal "under_win_pct"
    t.decimal "favorite_win_pct"
    t.decimal "underdog_win_pct"
    t.integer "best_bet_wins"
    t.integer "best_bet_losses"
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
    t.boolean "locked", default: false
  end

  create_table "team_games", force: :cascade do |t|
    t.integer "season_type"
    t.integer "year"
    t.string "team_abbreviation"
    t.string "team_name"
    t.integer "wins"
    t.integer "losses"
    t.string "opponent_name"
    t.date "day"
    t.datetime "date_time"
    t.string "home_or_away"
    t.integer "num_games"
    t.integer "minutes"
    t.integer "field_goals_made"
    t.integer "field_goals_attempted"
    t.decimal "field_goals_percentage"
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
    t.integer "assists"
    t.integer "steals"
    t.integer "blocked_shots"
    t.integer "turnovers"
    t.integer "personal_fouls"
    t.integer "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "team_id"
    t.bigint "season_id"
    t.bigint "game_id"
    t.bigint "opponent_id"
    t.decimal "performance"
    t.string "home_away_neutral"
    t.decimal "defensive_style_advantage"
    t.decimal "three_pointers_advantage"
    t.decimal "pace_advantage"
    t.decimal "assists_advantage"
    t.decimal "effective_field_goals_percentage"
    t.decimal "true_shooting_percentage"
    t.decimal "free_throws_rate"
    t.decimal "blocks_percentage"
    t.decimal "steals_percentage"
    t.decimal "assists_percentage"
    t.decimal "turnovers_percentage"
    t.decimal "pace"
    t.decimal "offensive_efficiency"
    t.decimal "defensive_efficiency"
    t.decimal "offensive_rebounds_percentage"
    t.decimal "defensive_rebounds_percentage"
    t.decimal "expected_ortg"
    t.decimal "expected_drtg"
    t.integer "player_of_the_game_id"
    t.boolean "locked", default: false
    t.integer "rank"
    t.index ["game_id"], name: "index_team_games_on_game_id"
    t.index ["opponent_id"], name: "index_team_games_on_opponent_id"
    t.index ["player_of_the_game_id"], name: "index_team_games_on_player_of_the_game_id"
    t.index ["season_id"], name: "index_team_games_on_season_id"
    t.index ["team_id"], name: "index_team_games_on_team_id"
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
    t.decimal "adj_offensive_efficiency"
    t.decimal "adj_defensive_efficiency"
    t.decimal "adj_tempo"
    t.decimal "offensive_efficiency"
    t.decimal "defensive_efficiency"
    t.decimal "effective_field_goals_percentage_allowed"
    t.decimal "turnovers_percentage_allowed"
    t.decimal "free_throws_rate"
    t.decimal "free_throws_rate_allowed"
    t.decimal "blocks_percentage_allowed"
    t.decimal "steals_percentage_allowed"
    t.decimal "three_pointers_rate"
    t.decimal "three_pointers_rate_allowed"
    t.decimal "assists_percentage_allowed"
    t.decimal "defensive_aggression"
    t.decimal "true_shooting_percentage_allowed"
    t.decimal "adj_efficiency_margin"
    t.integer "adjem_rank"
    t.string "defensive_fingerprint"
    t.decimal "home_advantage"
    t.decimal "defensive_style_advantage"
    t.decimal "three_pointers_advantage"
    t.decimal "pace_advantage"
    t.decimal "assists_advantage"
    t.decimal "r_defensive_style"
    t.decimal "r_three_pointers"
    t.decimal "r_assists"
    t.decimal "r_pace"
    t.decimal "consistency"
    t.decimal "three_pointers_proficiency"
    t.decimal "initial_adj_o"
    t.decimal "initial_adj_d"
    t.decimal "initial_adj_t"
    t.boolean "locked", default: false
    t.bigint "conference_id"
    t.decimal "three_pointers_percentage_allowed"
    t.decimal "two_pointers_percentage_allowed"
    t.decimal "strength_of_schedule"
    t.decimal "ooc_strength_of_schedule"
    t.index ["conference_id"], name: "index_team_seasons_on_conference_id"
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
    t.decimal "adj_efficiency_margin"
    t.decimal "adj_offensive_efficiency"
    t.decimal "adj_defensive_efficiency"
    t.decimal "adj_tempo"
    t.integer "adjem_rank"
    t.boolean "active"
    t.boolean "locked", default: false
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

  add_foreign_key "blog_posts", "teams"
  add_foreign_key "blog_posts", "users"
  add_foreign_key "games", "seasons"
  add_foreign_key "games", "stadia"
  add_foreign_key "games", "teams", column: "away_team_id"
  add_foreign_key "games", "teams", column: "home_team_id"
  add_foreign_key "player_games", "games"
  add_foreign_key "player_games", "player_seasons"
  add_foreign_key "player_games", "players"
  add_foreign_key "player_games", "seasons"
  add_foreign_key "player_games", "teams"
  add_foreign_key "player_games", "teams", column: "opponent_id"
  add_foreign_key "player_seasons", "conferences"
  add_foreign_key "player_seasons", "players"
  add_foreign_key "player_seasons", "seasons"
  add_foreign_key "player_seasons", "team_seasons"
  add_foreign_key "player_seasons", "teams"
  add_foreign_key "players", "teams"
  add_foreign_key "predictions", "games"
  add_foreign_key "predictions", "seasons"
  add_foreign_key "team_games", "games"
  add_foreign_key "team_games", "seasons"
  add_foreign_key "team_games", "teams"
  add_foreign_key "team_games", "teams", column: "opponent_id"
  add_foreign_key "team_seasons", "conferences"
  add_foreign_key "team_seasons", "seasons"
  add_foreign_key "team_seasons", "teams"
  add_foreign_key "teams", "conferences"
  add_foreign_key "teams", "stadia"
end

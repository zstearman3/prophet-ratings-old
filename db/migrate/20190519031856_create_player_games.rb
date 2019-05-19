class CreatePlayerGames < ActiveRecord::Migration[5.1]
  def change
    create_table :player_games do |t|
      t.integer :season_type
      t.integer :year
      t.string :name
      t.string :team_name
      t.string :position
      t.string :injury_status
      t.string :opponent_name
      t.date :day
      t.datetime :date_time
      t.string :home_or_away
      t.integer :games
      t.integer :minutes
      t.integer :field_goals_made
      t.integer :field_goals_attempted
      t.decimal :field_goals_percentage
      t.integer :two_pointers_made
      t.integer :two_pointers_attempted
      t.decimal :two_pointers_percentage
      t.integer :three_pointers_made
      t.integer :three_pointers_attempted
      t.decimal :three_pointers_percentage
      t.integer :free_throws_made
      t.integer :free_throws_attempted
      t.integer :free_throws_percentage
      t.integer :offensive_rebounds
      t.integer :defensive_rebounds
      t.integer :rebounds
      t.integer :assists
      t.integer :steals
      t.integer :blocked_shots
      t.integer :turnovers
      t.integer :personal_fouls
      t.integer :points
      t.timestamps
    end
  end
end

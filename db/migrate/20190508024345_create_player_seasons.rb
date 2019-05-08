class CreatePlayerSeasons < ActiveRecord::Migration[5.1]
  def change
    create_table :player_seasons do |t|
      t.integer :season_type
      t.integer :year
      t.string :name
      t.string :team_name
      t.string :position
      t.datetime :updated
      t.integer :games
      t.integer :minutes
      t.integer :field_goals_made
      t.integer :field_goals_attempted
      t.decimal :field_goals_percentage
      t.decimal :effective_field_goals_percentage
      t.integer :two_pointers_made
      t.integer :two_pointers_attempted
      t.decimal :two_pointers_percentage
      t.integer :three_pointers_made
      t.integer :three_pointers_attempted
      t.decimal :three_pointers_percentage
      t.integer :free_throws_made
      t.integer :free_throws_attempted
      t.decimal :free_throws_percentage
      t.integer :offensive_rebounds
      t.integer :defensive_rebounds
      t.integer :rebounds
      t.decimal :offensive_rebounds_percentage
      t.decimal :defensive_rebounds_percentage
      t.decimal :total_rebounds_percentage
      t.integer :assists
      t.integer :steals
      t.integer :blocked_shots
      t.integer :turnovers
      t.integer :personal_fouls
      t.integer :points
      t.decimal :true_shooting_percentage
      t.decimal :player_efficiency_rating
      t.decimal :assists_percentage
      t.decimal :steals_percentage
      t.decimal :blocks_percentage
      t.decimal :turnovers_percentage
      t.decimal :usage_rate
      t.timestamps
    end
  end
end

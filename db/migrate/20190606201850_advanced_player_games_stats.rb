class AdvancedPlayerGamesStats < ActiveRecord::Migration[5.1]
  def change
    add_column :player_games, :bpm, :decimal
    add_column :player_games, :offensive_bpm, :decimal
    add_column :player_games, :defensive_bpm, :decimal
    add_column :player_games, :game_score, :decimal
    add_column :player_games, :per, :decimal
    add_column :player_games, :offensive_rebounds_percentage, :decimal
    add_column :player_games, :defensive_rebounds_percentage, :decimal
    add_column :player_games, :rebounds_percentage, :decimal
    add_column :player_games, :steals_percentage, :decimal
    add_column :player_games, :blocks_percentage, :decimal
    add_column :player_games, :assists_percentage, :decimal
    add_column :player_games, :usage_rate, :decimal
    add_column :player_games, :turnovers_percentage, :decimal
    add_column :player_games, :true_shooting_percentage, :decimal
    add_column :player_games, :effective_field_goals_percentage, :decimal
  end
end

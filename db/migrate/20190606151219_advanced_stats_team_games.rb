class AdvancedStatsTeamGames < ActiveRecord::Migration[5.1]
  def change
    add_column :team_games, :effective_field_goals_percentage, :decimal
    add_column :team_games, :true_shooting_percentage, :decimal
    add_column :team_games, :free_throws_rate, :decimal
    add_column :team_games, :blocks_percentage, :decimal
    add_column :team_games, :steals_percentage, :decimal
    add_column :team_games, :assists_percentage, :decimal
    add_column :team_games, :turnovers_percentage, :decimal
    add_column :team_games, :pace, :decimal
    add_column :team_games, :offensive_efficiency, :decimal
    add_column :team_games, :defensive_efficiency, :decimal
    add_column :team_games, :offensive_rebounds_percentage, :decimal
    add_column :team_games, :defensive_rebounds_percentage, :decimal
    add_column :team_games, :expected_ortg, :decimal
    add_column :team_games, :expected_drtg, :decimal
  end
end

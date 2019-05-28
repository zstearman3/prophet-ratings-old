class AddAdvantageColumnsToTeamGames < ActiveRecord::Migration[5.1]
  def change
    add_column :team_games, :performance, :decimal
    add_column :team_games, :home_away_neutral, :string
    add_column :team_games, :defensive_style_advantage, :decimal
    add_column :team_games, :three_pointers_advantage, :decimal
    add_column :team_games, :pace_advantage, :decimal
    add_column :team_games, :assists_advantage, :decimal
  end
end

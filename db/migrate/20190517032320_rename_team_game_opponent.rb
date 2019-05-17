class RenameTeamGameOpponent < ActiveRecord::Migration[5.1]
  def change
    rename_column :team_games, :opponent, :opponent_name
    rename_column :team_games, :field_goals_missed, :field_goals_attempted
  end
end

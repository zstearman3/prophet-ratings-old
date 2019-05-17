class AddRelationshipsToTeamGames < ActiveRecord::Migration[5.1]
  def change
    add_reference :team_games, :team, foreign_key: true
    add_reference :team_games, :season, foreign_key: true
    add_reference :team_games, :game, foreign_key: true
    add_reference :team_games, :opponent, references: :teams, foreign_key: { to_table: :teams }
  end
end

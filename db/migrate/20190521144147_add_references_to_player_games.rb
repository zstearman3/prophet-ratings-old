class AddReferencesToPlayerGames < ActiveRecord::Migration[5.1]
  def change
    add_reference :player_games, :team, foreign_key: true
    add_reference :player_games, :player, foreign_key: true
    add_reference :player_games, :player_season, foreign_key: true
    add_reference :player_games, :season, foreign_key: true
    add_reference :player_games, :game, foreign_key: true
    add_reference :player_games, :opponent, references: :teams, foreign_key: { to_table: :teams }
  end
end

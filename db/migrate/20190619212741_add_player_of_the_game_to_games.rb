class AddPlayerOfTheGameToGames < ActiveRecord::Migration[5.1]
  def change
    add_reference :games, :player_of_the_game, references: :players, foreign_key: { to_table: :players }
    add_reference :team_games, :player_of_the_game, references: :players, foreign_key: { to_table: :players }
  end
end

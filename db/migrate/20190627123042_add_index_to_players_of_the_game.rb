class AddIndexToPlayersOfTheGame < ActiveRecord::Migration[5.1]
  def change
    add_index :games, :player_of_the_game_id
    add_index :team_games, :player_of_the_game_id
  end
end

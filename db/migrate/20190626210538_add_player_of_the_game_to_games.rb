class AddPlayerOfTheGameToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :player_of_the_game_id, :integer
    add_column :team_games, :player_of_the_game_id, :integer
    add_column :player_games, :prophet_rating, :decimal
  end
end

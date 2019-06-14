class AddPpgToPlayerSeasons < ActiveRecord::Migration[5.1]
  def change
    add_column :player_seasons, :points_per_game, :decimal
    add_column :player_seasons, :rebounds_per_game, :decimal
    add_column :player_seasons, :minutes_per_game, :decimal
    add_column :player_seasons, :minutes_percentage, :decimal
    add_column :player_seasons, :games_percentage, :decimal
    add_column :player_games, :qualified, :boolean
  end
end

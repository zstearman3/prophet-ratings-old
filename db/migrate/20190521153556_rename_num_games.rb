class RenameNumGames < ActiveRecord::Migration[5.1]
  def change
    rename_column :player_games, :games, :num_games
  end
end

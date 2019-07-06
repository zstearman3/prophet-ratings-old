class AssistsPerGame < ActiveRecord::Migration[5.1]
  def change
    add_column :player_seasons, :assists_per_game, :decimal
    add_column :player_seasons, :steals_per_game, :decimal
    add_column :player_seasons, :blocks_per_game, :decimal
  end
end

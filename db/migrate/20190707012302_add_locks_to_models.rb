class AddLocksToModels < ActiveRecord::Migration[5.1]
  def change
    add_column :conferences, :locked, :boolean, default: false
    add_column :games, :locked, :boolean, default: false
    add_column :players, :locked, :boolean, default: false
    add_column :player_games, :locked, :boolean, default: false
    add_column :player_seasons, :locked, :boolean, default: false
    add_column :stadia, :locked, :boolean, default: false
    add_column :teams, :locked, :boolean, default: false
    add_column :team_games, :locked, :boolean, default: false
    add_column :team_seasons, :locked, :boolean, default: false
  end
end

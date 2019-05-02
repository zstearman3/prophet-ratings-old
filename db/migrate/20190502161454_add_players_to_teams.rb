class AddPlayersToTeams < ActiveRecord::Migration[5.1]
  def change
    add_reference :players, :team, foreign_key: true
    add_column :players, :active, :boolean
  end
end

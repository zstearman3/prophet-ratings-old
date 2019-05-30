class AddAdjemToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :adj_efficiency_margin, :decimal
    add_column :teams, :adj_offensive_efficiency, :decimal
    add_column :teams, :adj_defensive_efficiency, :decimal
    add_column :teams, :adj_tempo, :decimal
    add_column :teams, :adjem_rank, :integer
  end
end

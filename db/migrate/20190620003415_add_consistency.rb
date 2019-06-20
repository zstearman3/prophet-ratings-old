class AddConsistency < ActiveRecord::Migration[5.1]
  def change
    add_column :team_seasons, :consistency, :decimal
    add_column :seasons, :consistency, :decimal
    add_column :seasons, :home_advantage, :decimal
    add_column :predictions, :win_straight_up, :boolean
    add_column :predictions, :confidence_straight_up, :decimal
  end
end

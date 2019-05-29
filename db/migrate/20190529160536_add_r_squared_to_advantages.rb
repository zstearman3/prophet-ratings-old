class AddRSquaredToAdvantages < ActiveRecord::Migration[5.1]
  def change
    add_column :team_seasons, :r_defensive_style, :decimal
    add_column :team_seasons, :r_three_pointers, :decimal
    add_column :team_seasons, :r_assists, :decimal
    add_column :team_seasons, :r_pace, :decimal
  end
end

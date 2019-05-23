class AddAdvancedStatsToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :possessions, :decimal
    add_column :games, :home_offensive_efficiency, :decimal
    add_column :games, :away_offensive_efficiency, :decimal
    add_column :games, :pace, :decimal
    add_column :games, :is_completed, :boolean
  end
end

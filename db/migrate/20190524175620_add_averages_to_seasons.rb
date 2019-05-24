class AddAveragesToSeasons < ActiveRecord::Migration[5.1]
  def change
    add_column :seasons, :adj_offensive_efficiency, :decimal
    add_column :seasons, :adj_defensive_efficiency, :decimal
    add_column :seasons, :adj_tempo, :decimal
    add_column :seasons, :offensive_efficiency, :decimal
    add_column :seasons, :defensive_efficiency, :decimal
    add_column :seasons, :effective_field_goals_percentage, :decimal
    add_column :seasons, :turnovers_percentage, :decimal
    add_column :seasons, :free_throws_rate, :decimal
    add_column :seasons, :offensive_rebounds_percentage, :decimal
    add_column :seasons, :defensive_rebounds_percentage, :decimal
    add_column :seasons, :blocks_percentage, :decimal
    add_column :seasons, :steals_percentage, :decimal
    add_column :seasons, :three_pointers_rate, :decimal
    add_column :seasons, :assists_percentage, :decimal
    add_column :seasons, :true_shooting_percentage, :decimal
  end
end

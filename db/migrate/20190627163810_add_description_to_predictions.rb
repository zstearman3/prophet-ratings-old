class AddDescriptionToPredictions < ActiveRecord::Migration[5.1]
  def change
    add_column :predictions, :description, :text
    add_column :predictions, :home_advantage, :decimal
    add_column :predictions, :defense_advantage, :decimal
    add_column :predictions, :assists_advantage, :decimal
    add_column :predictions, :three_pointers_advantage, :decimal
    add_column :predictions, :pace_advantage, :decimal
    add_column :predictions, :injury_advantage, :decimal
    add_column :team_seasons, :three_pointers_proficiency, :decimal
    add_column :seasons, :three_pointers_proficiency, :decimal
  end
end

class AddAdvancedTeamStats < ActiveRecord::Migration[5.1]
  def change
    add_column :team_seasons, :adj_offensive_efficiency, :decimal
    add_column :team_seasons, :adj_defensive_efficiency, :decimal
    add_column :team_seasons, :adj_tempo, :decimal
    add_column :team_seasons, :offensive_efficiency, :decimal
    add_column :team_seasons, :defensive_efficiency, :decimal
    add_column :team_seasons, :effective_field_goals_percentage_allowed, :decimal
    add_column :team_seasons, :turnovers_percentage_allowed, :decimal
    add_column :team_seasons, :free_throws_rate, :decimal
    add_column :team_seasons, :free_throws_rate_allowed, :decimal
    add_column :team_seasons, :blocks_percentage_allowed, :decimal
    add_column :team_seasons, :steals_percentage_allowed, :decimal
    add_column :team_seasons, :three_pointers_rate, :decimal
    add_column :team_seasons, :three_pointers_rate_allowed, :decimal
    add_column :team_seasons, :assists_percentage_allowed, :decimal
    add_column :team_seasons, :defensive_fingerprint, :decimal
    add_column :team_seasons, :true_shooting_percentage_allowed, :decimal
  end
end

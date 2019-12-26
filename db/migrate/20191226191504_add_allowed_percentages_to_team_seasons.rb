class AddAllowedPercentagesToTeamSeasons < ActiveRecord::Migration[5.1]
  def change
    add_column :team_seasons, :three_pointers_percentage_allowed, :decimal
    add_column :team_seasons, :two_pointers_percentage_allowed, :decimal
    add_column :team_seasons, :strength_of_schedule, :decimal
    add_column :team_seasons, :ooc_strength_of_schedule, :decimal
  end
end

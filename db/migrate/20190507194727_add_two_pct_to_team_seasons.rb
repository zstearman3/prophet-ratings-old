class AddTwoPctToTeamSeasons < ActiveRecord::Migration[5.1]
  def change
    add_column :team_seasons, :two_pointers_percentage, :decimal
    rename_column :team_seasons, :assistes_percentage, :assists_percentage
  end
end

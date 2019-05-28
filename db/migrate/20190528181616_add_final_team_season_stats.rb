class AddFinalTeamSeasonStats < ActiveRecord::Migration[5.1]
  def change
    add_column :team_seasons, :adjem_rank, :integer
    rename_column :team_seasons, :defensive_fingerprint, :defensive_aggression
    add_column :team_seasons, :defensive_fingerprint, :string
    add_column :team_seasons, :home_advantage, :decimal
    add_column :team_seasons, :defensive_style_advantage, :decimal
    add_column :team_seasons, :three_pointers_advantage, :decimal
    add_column :team_seasons, :pace_advantage, :decimal
    add_column :team_seasons, :assists_advantage, :decimal
  end
end

class AddAoemToTeamSeasons < ActiveRecord::Migration[5.1]
  def change
    add_column :team_seasons, :adj_efficiency_margin, :decimal
  end
end

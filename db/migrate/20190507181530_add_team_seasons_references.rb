class AddTeamSeasonsReferences < ActiveRecord::Migration[5.1]
  def change
    add_reference :team_seasons, :team, foreign_key: true
    add_reference :team_seasons, :season, foreign_key: true
  end
end

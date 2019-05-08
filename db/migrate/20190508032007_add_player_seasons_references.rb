class AddPlayerSeasonsReferences < ActiveRecord::Migration[5.1]
  def change
    add_reference :player_seasons, :player, foreign_key: true
    add_reference :player_seasons, :team, foreign_key: true
    add_reference :player_seasons, :season, foreign_key: true
    add_reference :player_seasons, :team_season, foreign_key: true
  end
end

class AddConferenceToSeasons < ActiveRecord::Migration[5.1]
  def change
    add_reference :player_seasons, :conference, foreign_key: true
    add_reference :team_seasons, :conference, foreign_key: true
  end
end

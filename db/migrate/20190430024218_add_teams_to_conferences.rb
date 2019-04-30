class AddTeamsToConferences < ActiveRecord::Migration[5.1]
  def change
    add_reference(:teams, :conference, foreign_key: true)
  end
end

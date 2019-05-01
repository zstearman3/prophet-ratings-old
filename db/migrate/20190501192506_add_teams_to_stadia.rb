class AddTeamsToStadia < ActiveRecord::Migration[5.1]
  def change
    add_reference(:teams, :stadium, foreign_key: true)
  end
end

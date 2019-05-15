class AddReferencesToGames < ActiveRecord::Migration[5.1]
  def change
    add_reference :games, :season, foreign_key: true
    add_reference :games, :home_team, references: :teams, foreign_key: { to_table: :teams }
    add_reference :games, :away_team, references: :teams, foreign_key: { to_table: :teams }
  end
end

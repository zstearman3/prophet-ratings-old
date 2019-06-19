class AddReferencesToPredictions < ActiveRecord::Migration[5.1]
  def change
    add_reference :predictions, :game, foreign_key: true
    add_reference :predictions, :season, foreign_key: true
  end
end

class CreatePredictions < ActiveRecord::Migration[5.1]
  def change
    create_table :predictions do |t|
      t.date :day
      t.integer :home_team_prediction
      t.integer :away_team_prediction
      t.integer :home_team_score
      t.integer :away_team_score
      t.decimal :point_spread
      t.decimal :over_under
      t.decimal :prediction_difference_point_spread
      t.decimal :prediction_difference_over_under
      t.decimal :confidence_point_spread
      t.decimal :confidence_over_under
      t.decimal :expected_value_point_spread
      t.decimal :expected_value_over_under
      t.boolean :home_favorite
      t.boolean :favorite_favorite
      t.boolean :pace_favorite
      t.timestamps
    end
  end
end

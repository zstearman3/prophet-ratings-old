class AddResultsToPredictions < ActiveRecord::Migration[5.1]
  def change
    add_column :predictions, :moneyline, :integer
    add_column :predictions, :prediction_difference_moneyline, :decimal
    add_column :predictions, :confidence_moneyline, :decimal
    add_column :predictions, :expected_value_moneyline, :decimal
    add_column :predictions, :win_point_spread, :boolean
    add_column :predictions, :win_over_under, :boolean
    add_column :predictions, :win_moneyline, :boolean
    add_column :predictions, :winnings_point_spread, :decimal
    add_column :predictions, :winnings_over_under, :decimal
    add_column :predictions, :winnings_moneyline, :decimal
    add_column :predictions, :predicted_point_spread, :decimal
    add_column :predictions, :predicted_over_under, :decimal
    add_column :predictions, :predicted_moneline, :integer
  end
end

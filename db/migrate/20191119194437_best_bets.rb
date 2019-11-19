class BestBets < ActiveRecord::Migration[5.1]
  def change
    add_column :predictions, :best_bet, :string
    add_column :predictions, :best_bet_value, :decimal
    add_column :predictions, :top_play, :boolean
    add_column :seasons, :over_win_pct, :decimal
    add_column :seasons, :under_win_pct, :decimal
    add_column :seasons, :favorite_win_pct, :decimal
    add_column :seasons, :underdog_win_pct, :decimal
    add_column :seasons, :best_bet_wins, :integer
    add_column :seasons, :best_bet_losses, :integer
  end
end

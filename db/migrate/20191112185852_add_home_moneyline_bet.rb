class AddHomeMoneylineBet < ActiveRecord::Migration[5.1]
  def change
    add_column :predictions, :home_moneyline_bet, :string
  end
end

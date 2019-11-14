class AddGameScore < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :thrill_score, :float
  end
end

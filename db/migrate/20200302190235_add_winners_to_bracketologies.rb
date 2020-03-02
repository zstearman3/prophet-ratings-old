class AddWinnersToBracketologies < ActiveRecord::Migration[5.1]
  def change
    add_column :bracketologies, :round_of_sixtyfour, :string
    add_column :bracketologies, :round_of_thirtytwo, :string
    add_column :bracketologies, :round_of_sixteen, :string
    add_column :bracketologies, :round_of_eight, :string
    add_column :bracketologies, :round_of_four, :string
    add_column :bracketologies, :round_of_two, :string
    add_column :bracketologies, :champion_id, :integer
  end
end

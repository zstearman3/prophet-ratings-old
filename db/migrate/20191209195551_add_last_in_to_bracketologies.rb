class AddLastInToBracketologies < ActiveRecord::Migration[5.1]
  def change
    add_column :bracketologies, :last_four_byes, :string
    add_column :bracketologies, :last_four_in, :string
    add_column :bracketologies, :first_four_out, :string
    add_column :bracketologies, :next_four_out, :string
  end
end

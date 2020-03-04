class AddUserToBracketology < ActiveRecord::Migration[5.1]
  def change
    add_column :bracketologies, :completed, :boolean, default: false
    add_reference :bracketologies, :user, foreign_key: true
  end
end

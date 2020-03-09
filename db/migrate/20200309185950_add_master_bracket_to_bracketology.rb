class AddMasterBracketToBracketology < ActiveRecord::Migration[5.1]
  def change
    add_column :bracketologies, :master_bracket, :boolean, default: false
  end
end

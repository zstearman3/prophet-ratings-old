class ChangeClassToYear < ActiveRecord::Migration[5.1]
  def change
    rename_column :players, :class, :year
  end
end

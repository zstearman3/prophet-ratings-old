class CreatePlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.integer :jersey
      t.string :position
      t.string :class
      t.integer :height
      t.integer :weight

      t.timestamps
    end
  end
end

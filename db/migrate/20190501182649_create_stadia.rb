class CreateStadia < ActiveRecord::Migration[5.1]
  def change
    create_table :stadia do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :country
      t.integer :capacity
      t.timestamps
    end
  end
end

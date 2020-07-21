class CreateRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :rankings do |t|
      t.date :date
      t.text :full_rankings
      t.timestamps
    end
  end
end

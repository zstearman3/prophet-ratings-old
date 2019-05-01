class CreateSeasons < ActiveRecord::Migration[5.1]
  def change
    create_table :seasons do |t|
      t.integer :season
      t.integer :start_year
      t.integer :end_year
      t.string :description
      t.date :regular_season_start_date
      t.date :regular_season_end_date
      
      t.index :season, unique: true
      t.timestamps
    end
  end
end

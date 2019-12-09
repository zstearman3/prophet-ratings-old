class CreateBracketologies < ActiveRecord::Migration[5.1]
  def change
    create_table :bracketologies do |t|
      t.string :tournament_field
      t.string :conference_winners
      t.date :date
      t.timestamps
    end
  end
end

class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.string :school
      t.string :name
      t.integer :ap_rank
      t.integer :wins
      t.integer :losses
      t.integer :conference_wins
      t.integer :conference_losses
      t.string :team_logo_url

      t.index :school, unique: true
      t.timestamps
    end
  end
end

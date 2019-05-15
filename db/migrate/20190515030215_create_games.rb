class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.integer :year
      t.integer :season_type
      t.string :status
      t.date :day
      t.datetime :date_time
      t.string :away_team_name
      t.string :home_team_name
      t.integer :away_team_score
      t.integer :home_team_score
      t.datetime :updated
      t.decimal :point_spread
      t.decimal :over_under
      t.integer :away_team_money_line
      t.integer :home_team_money_line
      t.string :bracket
      t.integer :round
      t.integer :away_team_seed
      t.integer :home_team_seed
      t.integer :away_team_previous_game_id
      t.integer :home_team_previous_game_id
      t.integer :tournament_display_order
      t.string  :tournament_display_order_for_home_team
      t.boolean :is_closed
      
      t.timestamps
    end
  end
end

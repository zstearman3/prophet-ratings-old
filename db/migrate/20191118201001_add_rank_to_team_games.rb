class AddRankToTeamGames < ActiveRecord::Migration[5.1]
  def change
   add_column :team_games, :rank, :integer
   add_column :predictions, :over_under_bet, :string
  end
end

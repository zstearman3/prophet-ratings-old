class PlayerGame < ApplicationRecord
  belongs_to :team
  belongs_to :player
  belongs_to :player_season, optional: true
  belongs_to :season
  belongs_to :game
  belongs_to :opponent, class_name: 'Team', foreign_key: 'opponent_id', optional: true
end

class TeamGame < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :season
  belongs_to :game
  belongs_to :opponent, class_name: 'Team', foreign_key: 'opponent_id', optional: true
  validates :day, presence: true
end

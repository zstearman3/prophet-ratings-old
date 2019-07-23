class Conference < ApplicationRecord
  has_many :teams
  has_many :team_games
  has_many :player_games
end

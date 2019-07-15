class Team < ApplicationRecord
  has_many :players
  has_many :player_seasons
  has_many :player_games
  has_many :team_seasons, dependent: :destroy
  has_many :team_games, dependent: :destroy
  has_many :opponent_games, class_name: 'TeamGame', foreign_key: 'opponent_id'
  has_many :opponent_player_games, class_name: 'PlayerGame', foreign_key: 'opponent_id'
  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_team_id'
  has_many :blog_posts
  belongs_to :conference
  belongs_to :stadium, optional: true
  validates :school, presence: true, uniqueness: { case_sensitive: false }
end

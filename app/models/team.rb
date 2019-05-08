class Team < ApplicationRecord
  has_many :players
  has_many :player_seasons
  has_many :team_seasons, dependent: :destroy
  belongs_to :conference
  belongs_to :stadium, optional: true
  validates :school, presence: true, uniqueness: { case_sensitive: false }
end

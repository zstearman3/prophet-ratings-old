class Season < ApplicationRecord
  has_many :team_seasons
  validates :season, presence: true, uniqueness: true
end

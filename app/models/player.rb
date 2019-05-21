class Player < ApplicationRecord
  belongs_to :team
  has_many :player_seasons, dependent: :destroy
  has_many :player_games, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :active,     presence: true
end

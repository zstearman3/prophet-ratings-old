class Player < ApplicationRecord
  belongs_to :team
  has_many :player_seasons, dependent: :destroy
  has_many :player_games, dependent: :destroy
  belongs_to :player_of_the_game, class_name: 'Game', foreign_key: 'player_of_the_game_id'
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :active,     inclusion: { in: [ true, false ] }
end

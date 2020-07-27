class Player < ApplicationRecord
  belongs_to :team
  has_many :player_seasons, dependent: :destroy
  has_many :player_games, dependent: :destroy
  has_many :player_of_the_games, class_name: 'Game', foreign_key: 'player_of_the_game_id'
  validates :first_name, presence: true
  validates :last_name,  presence: true
  validates :active,     inclusion: { in: [ true, false ] }
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def full_display
    "##{jersey} #{full_name}"
  end
  
  def height_in_feet
    height.to_i == 0 ? nil : "#{height / 12}' #{height % 12}\""
  end
  
  def weight_in_lbs
    weight.to_i == 0 ? nil : "#{weight} lbs"
  end
  
  def description
    description_string = "#{year}"
    description_string += " • #{position}" if position
    description_string += " • #{height_in_feet}" if height_in_feet
    description_string += " • #{weight_in_lbs}" if weight_in_lbs
    return description_string
  end
end

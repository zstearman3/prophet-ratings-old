class Stadium < ApplicationRecord
  validates :name, presence: true
  validates :city, presence: true
  has_many :teams
end

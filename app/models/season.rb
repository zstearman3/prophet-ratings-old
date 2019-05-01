class Season < ApplicationRecord
  validates :season, presence: true, uniqueness: true
end

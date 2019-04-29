class Team < ApplicationRecord
  validates :school, presence: true, uniqueness: { case_sensitive: false }
end

class Team < ApplicationRecord
  belongs_to :conference
  validates :school, presence: true, uniqueness: { case_sensitive: false }
end

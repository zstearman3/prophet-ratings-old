class Team < ApplicationRecord
  belongs_to :conference
  belongs_to :stadium, optional: true
  validates :school, presence: true, uniqueness: { case_sensitive: false }
end

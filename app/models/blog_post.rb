class BlogPost < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :user
  validates :title, presence: true
  validates :date, presence: true
  validates :body, presence: true
end

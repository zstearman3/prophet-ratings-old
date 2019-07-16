require 'uri'

class BlogPost < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :user
  validates :title, presence: true
  validates :date, presence: true
  validates :body, presence: true
  validates :url_path, presence: true
  
  def get_url_path
    URI.encode(title.downcase)
  end
  
  def to_param
    url_path
  end
end

class Conference < ApplicationRecord
  has_many :teams
  has_many :team_games
  has_many :player_games
  
  def self.conferences
      conferences = self.order(name: :asc).all.as_json
      conferences << {"id" => 40, "name" => "Powers"}
      conferences << {"id" => 50, "name" => "Mid-Majors"}
  end
  
  def self.return_ids(id)
    return nil if (id.to_i == 0)
    if id.to_i == 50
      mid_major_conferences
    elsif id.to_i == 40
      major_conferences
    else
      id
    end
  end
  
  
  private
    def self.mid_major_conferences
      [2, 4, 5, 7, 8, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 25, 27, 28, 29, 30, 31, 32, 33]
    end
    
    def self.major_conferences
      [1, 3, 6, 9, 10, 15, 24, 26]
    end
    
end

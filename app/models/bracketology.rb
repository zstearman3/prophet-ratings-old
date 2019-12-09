class Bracketology < ApplicationRecord
  serialize :tournament_field, Array
  serialize :conference_winners, Array
end

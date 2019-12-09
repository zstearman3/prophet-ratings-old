class Bracketology < ApplicationRecord
  serialize :tournament_field, Array
  serialize :conference_winners, Array
  serialize :last_four_byes, Array
  serialize :last_four_in, Array
  serialize :first_four_out, Array
  serialize :next_four_out, Array
end

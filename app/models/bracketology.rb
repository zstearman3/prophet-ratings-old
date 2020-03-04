class Bracketology < ApplicationRecord
  serialize :tournament_field, Array
  serialize :conference_winners, Array
  serialize :last_four_byes, Array
  serialize :last_four_in, Array
  serialize :first_four_out, Array
  serialize :next_four_out, Array
  serialize :round_of_sixtyfour, Array
  serialize :round_of_thirtytwo, Array
  serialize :round_of_sixteen, Array
  serialize :round_of_eight, Array
end

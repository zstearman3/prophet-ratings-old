require 'test_helper'

class PlayerSeasonTest < ActiveSupport::TestCase
  def setup
    @season = player_seasons(:one)
  end
  
  test 'should be valid' do
    assert @season.valid?
  end
  
  test 'should require name' do
    @season.name = "    "
    assert_not @season.valid?
  end
end

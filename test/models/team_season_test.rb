require 'test_helper'

class TeamSeasonTest < ActiveSupport::TestCase
  def setup
    @season = team_seasons(:one)
  end
  
  test "should be valid" do
    assert @season.valid?
  end
  
  test "should require team" do
    @season.team_id = nil
    assert_not @season.valid?
  end
end

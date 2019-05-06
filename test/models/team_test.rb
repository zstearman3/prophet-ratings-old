require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    @team = teams(:sooners)
  end
  
  test "should be valid" do
    assert @team.valid?
  end
  
  test "should require school name" do
    @team.school = "      "
    assert_not @team.valid?
  end
  
  test "should require conference" do
    @team.conference = nil
    assert_not @team.valid?
  end
end

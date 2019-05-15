require 'test_helper'

class GameTest < ActiveSupport::TestCase
  def setup
    @game = games(:one)
  end
  
  test "should be valid" do
    assert @game.valid?
  end
  
  test "should require date" do
    @game.day = nil
    assert_not @game.valid?
  end
  
end

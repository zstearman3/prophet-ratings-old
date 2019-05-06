require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @player = players(:one)
  end
  
  test "should get team" do
    get player_path(@player)
    assert_response :success
  end
end

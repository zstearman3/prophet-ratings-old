require 'test_helper'

class PlayerSeasonsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end
  
  test "should get player shooting" do
    get player_shooting_path(season: '2019')
    assert_response :success
  end
end

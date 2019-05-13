require 'test_helper'

class TeamSeasonsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end
  
  test "should get team shooting" do
    get team_shooting_path(season: '2019')
    assert_response :success
  end
end

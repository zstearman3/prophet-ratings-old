require 'test_helper'

class TeamSeasonsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
  end
  
  test "should get index" do
    get team_seasons_path(season: '2019')
    assert_response :success
  end
end

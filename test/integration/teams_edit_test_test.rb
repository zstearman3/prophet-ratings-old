require 'test_helper'

class TeamsEditTestTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    @team = teams(:sooners)
  end
  
  test "successful edit" do
    get edit_team_path(@team)
    assert_redirected_to login_path
    log_in_as @user
    get edit_team_path(@team)
    school = "Villanova"
    patch team_path(@team), params: { team: { school: school,
                                              conference_id: @team.conference_id } }
    assert_not flash.empty?
    assert_redirected_to @team
    @team.reload
    assert_equal school, @team.school
  end
end
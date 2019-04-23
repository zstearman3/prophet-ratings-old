require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get root_url
    assert_response :success
    assert_select "title", "Home | ProphetRatings"
  end

  test "should get help" do
    get help_path
    assert_response :success
  end

end

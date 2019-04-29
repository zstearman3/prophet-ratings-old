require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @other_user = users(:two)
  end

  test "should get index" do
    log_in_as @user
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post users_path, params: { user: { first_name: "examples", last_name: "username", email: "test@email.com",
                                        password: "foobar", password_confirmation: "foobar"} }
    end

    assert_redirected_to root_url
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    log_in_as @user
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    log_in_as @user
    patch user_url(@user), params: { user: { email: @user.email, first_name: @user.first_name,
                                             password: '', password_confirmation: ''} }
    assert_redirected_to user_url(@user)
  end
  
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password: 'password',
                                            password_confirmation: 'password',
                                            admin: true } }
    assert_not @other_user.admin?
  end
  
  test "should destroy user" do
    log_in_as @user
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end

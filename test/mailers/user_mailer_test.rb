require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:one)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account Activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@prophetratings.com"], mail.from
    assert_match user.first_name,        mail.body.encoded
    assert_match user.activation_token,  mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

end

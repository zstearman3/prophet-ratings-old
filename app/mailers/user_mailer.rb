class UserMailer < ApplicationMailer

  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account Activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password Reset"
  end
  
  def account_creation(admin, user)
    @user = user
    @admin = admin
    mail to: admin.email, subject: "New User!"
  end
end

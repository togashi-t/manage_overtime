class Users::SessionsController < Devise::SessionsController
  def guest
    user = User.find_by(email: "guest@email.com")
    sign_in user
    redirect_to root_path, notice: "ゲストユーザーとしてログインしました。"
  end
end

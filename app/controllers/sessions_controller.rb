class SessionsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user&.authenticate(params[:session][:password])
      # ログイン後のページにリダイレク
      log_in(@user)
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      Rails.logger.info params[:session][:remember_me]
      # 自動的に user_url(@user) -> users/:id に変換している
      redirect_to @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end

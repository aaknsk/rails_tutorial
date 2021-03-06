# frozen_string_literal: true

# 認証のためのセッションを扱うメソッド集
module SessionsHelper
  # 渡されたuserでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在ログインしているユーザーを返す(いる場合)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # &.で存在していれば、後述のメソッドを実行することができる
      if user && user&.authenticated?(cookies[:remember_token])
        log_in(user)
        @current_user = user
      end

    end
  end

  # ユーザーがログインしていればtrue,その他ならfalse
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破壊する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end

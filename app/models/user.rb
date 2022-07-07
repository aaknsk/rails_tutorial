class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  # '!'をつけることで直接変更可能になる
  # before_save { self.email = email.downcase }
  before_save { email.downcase! }

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  class << self
    # 渡された文字列のハッシュ値を返す
    def digest(string)
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    # return randam token
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # 永続セッションのために、ユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す, このremember_tokenはクラス変数とは別物の引数
  # ここで使用している remember_digestはUsersテーブル内のカラム
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # write class_method self.method_name style
  # def self.digest(string)
  #   cost = if ActiveModel::SecurePassword.min_cost
  #            BCrypt::Engine::MIN_COST
  #          else
  #            BCrypt::Engine.cost
  #          end
  #   BCrypt::Password.create(string, cost: cost)
  # end

  # # return randam token
  # def self.new_token
  #   SecureRandom.urlsafe_base64
  # end
end

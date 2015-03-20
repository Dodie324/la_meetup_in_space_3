class User < ActiveRecord::Base
  validates :provider, presence: true, uniqueness: true
  validates :uid, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[a-z0-9_.+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+\z/ }
  validates :avatar_url, presence: true

  has_many :comments, inverse_of: :user


  has_many :user_meetups
  has_many :meetups, through: :user_meetups

  def self.find_or_create_from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid

    find_by(provider: provider, uid: uid) || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      username: auth.info.nickname,
      avatar_url: auth.info.image
    )
  end
end

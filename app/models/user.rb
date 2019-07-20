class User < ApplicationRecord
  attr_accessor :remember_token
  mount_uploader :avatar, AvatarUploader
  validates :name,
    presence: true,
    length: {maximum: Settings.maximum_name_length}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    length: {maximum: Settings.maximum_email_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: true}

  has_secure_password
  validates :password,
    presence: true,
    length: {minimum: Settings.minimum_pw_length},
    allow_nil: true

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    User.update id, remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    User.update id, remember_digest: nil
  end
end

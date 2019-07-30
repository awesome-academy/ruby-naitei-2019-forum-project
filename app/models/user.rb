class User < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :joined_forums, through: :members, source: :sub_forum

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :email_downcase
  before_create :create_activation_digest
  mount_uploader :avatar, AvatarUploader
  has_many :sub_forums, dependent: :destroy
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
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    User.update id, remember_digest: User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    User.update id, remember_digest: nil
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token),
                      reset_sent_at: Time.zone.now
  end

  def password_reset_expired?
    reset_sent_at < Settings.password_expired.hours.ago
  end

  def join sub_forum, member_type
    joined_forums << sub_forum
    member = Member.find_by user_id: id, sub_forum_id: sub_forum.id
    member.update_attributes user_type: member_type
  end

  def leave sub_forum
    joined_forums.delete sub_forum
  end

  def joined_forums? sub_forum
    joined_forums.include? sub_forum
  end

  private

  def email_downcase
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end

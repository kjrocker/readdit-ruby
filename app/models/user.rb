class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  has_many :posts
  has_many :comments

  # Simple wrapper for Knock, making it easy to grab new tokens
  def to_jwt
    Knock::AuthToken.new(payload: { sub: id }).token
  end
end

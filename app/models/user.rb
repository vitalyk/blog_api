class User < ApplicationRecord
  before_save :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true, length: { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :user_name, presence: true, length: { maximum: 50 }
  has_secure_password

  def custom_response
    { email: email, user_name: user_name }
  end

  private

    # Converts email to all lower-case.
    def downcase_email
      email.downcase!
    end
end

class User < ApplicationRecord
  has_secure_password
  has_one :conversation, dependent: :destroy

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: true },
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: 'is not a valid email'
            }

  def self.find_filtered(email: nil)
    self.where(email: email).select(self.attribute_names - ['password_digest'])
  end
end

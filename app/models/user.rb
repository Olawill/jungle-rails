class User < ApplicationRecord
  has_secure_password

  PASSWORD_REQUIREMENTS = /\A 
    (?=.{8,}) # At least 8 characters long
  /x

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  validates :password, format: PASSWORD_REQUIREMENTS

  def self.authenticate_with_credentials(email, password)
    # Find the user by email in a case-insensitive manner
    user = User.find_by('LOWER(email) = ?', email.downcase.strip)

    # Check if the user exists and the password is correct
    user && user.authenticate(password) ? user : nil
  end
end

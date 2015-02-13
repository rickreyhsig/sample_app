require 'digest'
class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  attr_accessor :remember_token
  attr_accessor :password
  #before_save { self.email = email.downcase }
  before_save { email.downcase! }
  attr_accessible :email, :name, :password, :password_confirmation
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }



  #validates :password, :confirmation => true
  #Automatically create the virtual attribute 'password_confirmation'.
  validates :password,  presence: true, confirmation: true, length: { :within => 6..40 }

  before_save :encrypt_password

  # Return true if users's passwd matches the submitted passwd.
  def has_password? (submitted_password)
    encrypted_password == encrypt(submitted_password)
    # Compare encrypted+password with the the encrypted version of submitted_password
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    #update_attribute(:remember_digest, User.digest(remember_token))
  end

 # Forgets a user.
  #def forget
  #  update_attribute(:remember_digest, nil)
  #end

  private

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
      #string # Only a temporary implementation
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

#  has_secure_password
#  validates :password, length: { minimum: 6 }
end

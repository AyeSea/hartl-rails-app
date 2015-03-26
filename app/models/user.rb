class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	#{ presence: true } is a one element options hash. 
	#curly braces may be omitted when a hash is the final argument in a method.

	#same as validates(:name, { presence: true })
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
			  		 format: { with: VALID_EMAIL_REGEX },
			  		 #rails infers uniqueness: true below
			  		 uniqueness: { case_sensitive: false }

	has_secure_password
	validates :password, length: { minimum: 6 }
end
class User < ApplicationRecord
	validates :email, :first_name, presence: true
	validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

end

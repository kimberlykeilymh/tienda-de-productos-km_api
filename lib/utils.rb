# frozen_string_literal: true

require 'bcrypt'

module Utils
	def encrypt_password(password)
		# TODO: add salt
		return BCrypt::Password.create(password)
	end

	def verify_password(hash, password)
		return BCrypt::Password.new(hash) == password
	end
end

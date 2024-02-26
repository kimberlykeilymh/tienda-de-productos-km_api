# frozen_string_literal: true

require 'sequel'

require_relative '../../lib/utils'

module Models
	class User < Sequel::Model
		include Utils
		
		plugin :validation_helpers

		one_to_many :products

		def validate
			super
			validates_presence [:username, :password_digest]
			validates_unique 	 [:username]
			# TODO: validate password format (regex: ^.*(?=.{8,})(?=.*[a-zA-Z])(?=.*\d)(?=.*[!#$%&? "]).*$)
		end

		def before_create
			super
			self.password_digest = encrypt_password(password_digest)
		end

		def self.authenticate(username, password)
			user = self.find(username: username)
			user && user.valid_password?(password) ? user : nil
		end

		def valid_password?(password)
			verify_password(password_digest, password)
		end
	end
end

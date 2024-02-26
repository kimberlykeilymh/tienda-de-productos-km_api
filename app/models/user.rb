# frozen_string_literal: true

require 'sequel'

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
	end
end

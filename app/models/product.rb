# frozen_string_literal: true

require 'sequel'

require_relative '../../lib/database_connection'

module Models
	class Product < Sequel::Model
		plugin :validation_helpers

		many_to_one :user

		def validate
			super
			validates_presence [:name, :price, :user_id]
			validates_unique	 [:name, :user_id]
		end
	end
end

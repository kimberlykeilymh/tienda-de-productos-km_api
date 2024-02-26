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

		def self.get_all_by_user_id(user_id)
			DatabaseConnection.db_client[:products].where(user_id:).all
		end
	end
end

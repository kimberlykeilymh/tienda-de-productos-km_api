# frozen_string_literal: true

require 'sequel'
require 'thread'

require_relative '../../lib/database_connection'
require_relative 'product'

module Models
	class ProductOperation < Sequel::Model
		plugin :validation_helpers

		many_to_one :product

		TYPE = { create: 'create' }
		STATUS = { pending: 'pending', completed: 'completed', failed: 'failed' }

		def validate
			super
			validates_presence [:type, :status, :product_payload, :user_id]
			validates_includes TYPE.values, :type
			validates_includes STATUS.values, :status
		end

		def before_validation
			super
			self.status = status || STATUS[:pending]
		end

		def after_create
			super
			Thread.new do
				sleep 5
				begin
					product_attributes = JSON.parse(product_payload).merge({ user_id: })
					product = Models::Product.create(product_attributes)
					self.product_id = product.id
					self.status = STATUS[:completed]
					self.save
				rescue
					# TODO: add message error to product operation
					self.status = STATUS[:failed]
					self.save
				end
			end
		end

		def self.get_by_user_id(id, user_id)
			product_operation = DatabaseConnection.db_client[:product_operations].where(id:, user_id:).first
		end
	end
end

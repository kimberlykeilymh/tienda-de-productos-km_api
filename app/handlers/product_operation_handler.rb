# frozen_string_literal: true

require_relative '../models/product_operation'

module Handlers
	module ProductOperation
		def handle_product_operation_request(request)
			case request.request_method
			when 'GET'
				get_product_operation(request)
			else
				RackResponse.method_not_allowed
			end
		end

		def get_product_operation(request)
			product_operation_id = get_resource_id_from_request(request)
			product_operation = Models::ProductOperation.get_by_user_id(product_operation_id, current_user_id(request))
			return RackResponse.not_found unless product_operation

			RackResponse.ok(product_operation)
		end
	end
end

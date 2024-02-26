# frozen_string_literal: true

require_relative '../models/product'

module Handlers
	module Product
		def handle_products_request(request)
			case request.request_method
			when 'GET'
				get_products(request)
			else
				RackResponse.method_not_allowed
			end
		end

		def get_products(request)
			# TOASK: can a user see only their products or the entire list?
			# It is assumed for the moment that the user can only see their products
			products = Models::Product.get_all_by_user_id(current_user_id(request))
			RackResponse.ok(products)
		end
	end
end

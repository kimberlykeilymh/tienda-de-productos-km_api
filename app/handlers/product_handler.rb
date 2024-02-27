# frozen_string_literal: true

require_relative '../models/product'
require_relative '../models/product_operation'

module Handlers
	module Product
		def handle_products_request(request)
			case request.request_method
			when 'GET'
				get_products(request)
			when 'POST'
				create_product(request)
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

		def create_product(request)
			request_data = parse_request_body(request)
			valid_request_data = valid_product_request_data?(request_data)
			return RackResponse.bad_request('Provide name and price') unless valid_request_data

			product_operation = Models::ProductOperation.create(
				type: Models::ProductOperation::TYPE[:create],
				product_payload: request_data.to_json,
				user_id: current_user_id(request)
			)
			RackResponse.accepted(build_product_operation_async_body(product_operation))
		end

		def valid_product_request_data?(request_data)
			request_data['name'] && request_data['price']
		end

		def build_product_operation_async_body(product_operation)
			{
				operation_id: product_operation.id,
				status: product_operation.status,
				created_at: product_operation.created_at,
				# TODO: improve href field to avoid literal string inside a method
				href: "/api/product-operation/#{ product_operation.id }"
			}
		end
	end
end

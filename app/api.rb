# frozen_string_literal: true

require 'rack'
require 'json'

require_relative '../lib/rack_response'
require_relative 'handlers/ping_handler'
require_relative 'handlers/authentication_handler'
require_relative 'handlers/product_handler'
require_relative 'handlers/product_operation_handler'

class Api
	include Handlers::Ping
	include Handlers::Authentication
	include Handlers::Product
	include Handlers::ProductOperation

	def call(env)
		request = Rack::Request.new(env)

		resource = get_resource_from_request(request)
		case resource
		when 'ping'
			handle_ping_request(request)
		when 'login'
			handle_authentication_request(request)
		when 'products'
			handle_products_request(request)
		when 'product-operation'
			handle_product_operation_request(request)
		else
			RackResponse.not_found
		end
	rescue Exception => e
		RackResponse.internal_server_error("Internal Server Error: #{e.message}")
	end

	private

	def parse_request_body(request)
		request_body = request.body.read
    request_body.empty? ? '' : JSON.parse(request_body)
  end

	def current_user_id(request)
		request.env['user_id']
	end

	def get_resource_from_request(request)
		# TODO: add support for nested resources
		# TODO: add validations
		request.path_info.split('/')[1]
	end

	def get_resource_id_from_request(request)
		# TODO: add support for nested resources
		# TODO: add validations
		request.path_info.split('/').last
	end
end

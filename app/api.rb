# frozen_string_literal: true

require 'rack'
require 'json'

require_relative '../lib/rack_response'
require_relative 'handlers/ping_handler'
require_relative 'handlers/authentication_handler'

class Api
	include Handlers::Ping
	include Handlers::Authentication

	def call(env)
		request = Rack::Request.new(env)
		case request.path_info
		when '/ping'
			handle_ping_request(request)
		when '/login'
			handle_authentication_request(request)
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
end

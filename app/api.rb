# frozen_string_literal: true

require 'rack'

require_relative '../lib/rack_response'

class Api
	def call(env)
		request = Rack::Request.new(env)
		case request.path_info
		when '/ping'
			handle_ping_request(request)
		else
			RackResponse.not_found
		end
	end
	
	private

	def handle_ping_request(request)
		case request.request_method
		when 'GET'
			RackResponse.ok('pong')
		else
			RackResponse.method_not_allowed
		end
	end
end

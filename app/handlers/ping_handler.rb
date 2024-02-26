# frozen_string_literal: true

module Handlers
	module Ping
		def handle_ping_request(request)
			case request.request_method
			when 'GET'
				RackResponse.ok('pong')
			else
				RackResponse.method_not_allowed
			end
		end
	end
end

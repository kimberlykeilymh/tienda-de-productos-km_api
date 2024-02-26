# frozen_string_literal: true

require 'rack'
require 'json'

class RackResponse
	class << self
		DEFAULT_HEADERS = {
			'Content-Type' => 'application/json' 
		}

		def ok(body)
			build_rack_response(200, body.to_json)
		end

		def bad_request(error = 'Bad Request')
			build_rack_response(400, { status: 400, error: }.to_json)
		end

		def authorization_required(error = 'Authorization Required')
			build_rack_response(401, { status: 401, error: }.to_json)
		end

		def forbidden(error = 'Forbidden')
			build_rack_response(403, { status: 403, error: }.to_json)
		end

		def not_found(error = 'Not found')
			build_rack_response(404, { status: 404, error: }.to_json)
		end

		def method_not_allowed(error = 'Method not allowed')
			build_rack_response(405, { status: 405, error: }.to_json)
		end

		def internal_server_error(error = 'Internal Server Error')
			build_rack_response(500, { status: 500, error: }.to_json)
		end

		private

		def build_rack_response(status, body, headers = DEFAULT_HEADERS)
			response = Rack::Response.new(body, status, headers)
			response.finish
		end
	end
end

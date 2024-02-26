# frozen_string_literal: true

require_relative '../../lib/jwt/token'
require_relative '../models/user'

module Handlers
	module Authentication
		def handle_authentication_request(request)
			case request.request_method
			when 'POST'
				authenticate_user(request)
			else
				RackResponse.method_not_allowed
			end
		end

		def authenticate_user(request)
			request_data = parse_request_body(request)
			valid_request_data = valid_authentication_request_data?(request_data)
			return RackResponse.bad_request('Provide username and password') unless valid_request_data

			user = Models::User.authenticate(request_data['username'], request_data['password'])
			return RackResponse.forbidden('The username or password is invalid') unless user

			# Json Web Token valid for 24 hours
			exp = Time.now + (60 * 60 * 24)
			token = JWT::Token.encode(user, exp)
			RackResponse.ok({ username: user.username, token:, exp: })
		end

		def valid_authentication_request_data?(request_data)
			request_data['username'] && request_data['password']
		end
	end
end

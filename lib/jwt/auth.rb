# frozen_string_literal: true

require 'jwt'

require_relative '../rack_response.rb'
require_relative 'token'

module JWT
	class Auth
		PATH_INFO_HEADER_KEY = 'PATH_INFO'
		PATH_API_FIXED_PART = '/api'
		EXCLUDED_PATHS = ['/ping', '/login']
		
		BEARER_TOKEN_HEADER_KEY = 'HTTP_AUTHORIZATION'
		BEARER_TOKEN_REGEX = %r{
			^Bearer\s{1}(       # starts with Bearer and a single space
			[a-zA-Z0-9\-\_]+\.  # 1 or more chars followed by a single period
			[a-zA-Z0-9\-\_]+\.  # 1 or more chars followed by a single period
			[a-zA-Z0-9\-\_]*    # 0 or more chars, no trailing chars
			)$
		}x
		
		def initialize(app, exclude_paths = EXCLUDED_PATHS)
			@app = app
			@exclude_paths = exclude_paths

			check_exclude_type!
		end

		def call(env)
			if path_matches_excluded_path?(env)
				@app.call(env)
			else
				verify_token(env)
			end
		end

		private

		def path_matches_excluded_path?(env)
			request_path = env[PATH_INFO_HEADER_KEY].sub(PATH_API_FIXED_PART, '')
			request_path.start_with?(*@exclude_paths)
		end

		def verify_token(env)
			token = get_request_bearer_token(env)
			decoded_token = JWT::Token.decode(token)

			env['user_id'] = decoded_token["data"]["user_id"]

			@app.call(env)
		rescue StandardError => e
			RackResponse.authorization_required(e.message)
		rescue JWT::VerificationError
			RackResponse.authorization_required('Invalid JWT token: Signature Verification Error')
		rescue JWT::ExpiredSignature
			RackResponse.authorization_required('Invalid JWT token: Expired Signature (exp)')
		rescue JWT::IncorrectAlgorithm
			RackResponse.authorization_required('Invalid JWT token: Incorrect Key Algorithm')
		rescue JWT::InvalidIatError
			RackResponse.authorization_required('Invalid JWT token: Invalid Issued At (iat)')
		rescue JWT::DecodeError
			RackResponse.authorization_required('Invalid JWT token: Decode Error')
		end

		def get_request_bearer_token(env)
			validate_request_bearer_token(env)
			env[BEARER_TOKEN_HEADER_KEY].split(' ').last
		end

		def validate_request_bearer_token(env)
			if env[BEARER_TOKEN_HEADER_KEY].nil? || env[BEARER_TOKEN_HEADER_KEY].strip.empty?
				raise StandardError, 'Missing Authorization header'
			end

			if env[BEARER_TOKEN_HEADER_KEY] !~ BEARER_TOKEN_REGEX
				raise StandardError, 'Invalid Authorization header format'
			end
		end

		def check_exclude_type!
			unless @exclude_paths.is_a?(Array)
				raise ArgumentError, 'exclude_paths argument must be an Array'
			end

			@exclude_paths.each do |path|
				unless path.is_a?(String)
					raise ArgumentError, 'each exclude_paths Array element must be a String'
				end

				if path.empty?
					raise ArgumentError, 'each exclude_paths Array element must not be empty'
				end

				unless path.start_with?('/')
					raise ArgumentError, 'each exclude_paths Array element must start with a /'
				end
			end
		end
	end
end

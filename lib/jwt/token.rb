# frozen_string_literal: true

require 'jwt'

module JWT
	class Token
		class << self
			SECRET_KEY = ENV['JWT_SECRET_KEY']
			ALGORITHM = ENV['JWT_ALGORITHM'] || 'HS256'
	
			def encode(user, exp)
				payload = build_payload(user, exp)
				JWT.encode(payload, SECRET_KEY, ALGORITHM)
			end
	
			def decode(token)
				body = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })[0]
			end
	
			private
	
			def build_payload(user, exp)
				# TODO: add a unique id (jti) for this token (for revocation purposes)
				{
					data: {
						user_id: user.id
					},
					exp: exp.to_i,
					iat: Time.now.to_i
				}
			end
		end
	end
end

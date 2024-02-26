# frozen_string_literal: true

class Api
	def call(env)
		[200, {}, ['Hello World']]
	end
end

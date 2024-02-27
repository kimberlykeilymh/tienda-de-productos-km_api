# frozen_string_literal: true

require 'dotenv/load'

require_relative 'lib/database_connection'
DatabaseConnection.create_tables

require_relative 'lib/jwt/auth'
require_relative 'app/api'

app = Rack::Builder.new do
	use Rack::Deflater
	use Rack::Static, 
		root: 'public',
		urls: ['/authors', '/openapi.yaml'],
		header_rules: [
			['/authors', { 'Cache-Control' => 'public, max-age=86400' }],
			['/openapi.yaml', { 'Cache-Control' => 'no-store' }]
		]
	use JWT::Auth
	map '/api' do
    run Api.new
  end
end

run app

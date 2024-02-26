# frozen_string_literal: true

require 'dotenv/load'

require_relative 'app/api'

app = Rack::Builder.new do
	map '/api' do
    run Api.new
  end
end

run app

# frozen_string_literal: true

require 'sequel'
require 'dotenv/load'

class DatabaseConnection
  class << self
		def db_client
			@@DB ||= connect
		end

    def connect
      Sequel.connect(
        adapter: ENV['DB_ADAPTER'],
        user: ENV['DB_USER'],
        password: ENV['DB_PASSWORD'],
        host: ENV['DB_HOST'],
        port: ENV['DB_PORT'],
        database: ENV['DB_NAME']
      )
    end

    def create_tables
      create_users_table
      create_products_table
			create_product_operation_table
    end

    private

    def create_users_table
      db_client.create_table? :users do
				primary_key :id
				String :username, null: false, index: true, unique: true
				String :password_digest, null: false
				Timestamp :created_at, default: Sequel.lit("now()")
      end
    end

    def create_products_table
      db_client.create_table? :products do
				primary_key :id
				String :name, null: false, index: true
        Float :price, default: 0.0, null: false
				Timestamp :created_at, default: Sequel.lit("now()")
				foreign_key :user_id, :users, null: false
				unique [:name, :user_id]
      end
    end

    def create_product_operation_table
      db_client.create_table? :product_operations do
				primary_key :id
				String :type, null: false
				String :status, null: false, default: 'pending'
				String :product_payload, null: false
				Timestamp :created_at, default: Sequel.lit("now()")
				foreign_key :product_id, :products
				foreign_key :user_id, :users, null: false
      end
    end
	end
end

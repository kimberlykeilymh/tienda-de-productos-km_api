# frozen_string_literal: true

require_relative '../lib/database_connection'

db = DatabaseConnection.db_client
db.drop_table?(:product_operations, :products, :users)
DatabaseConnection.create_tables

require_relative '../app/models/user'
require_relative '../app/models/product'

user_a = Models::User.create(username: 'kmendoza', password_digest: 'pFwwG.gnk!')
user_b = Models::User.create(username: 'kkeily', password_digest: 'zetyu8;ng')

Models::Product.create(name: 'Product A', price: 1500.99, user_id: user_a.id)
Models::Product.create(name: 'Product B', price: 799.99, user_id: user_a.id)
Models::Product.create(name: 'Product C', price: 2500.99, user_id: user_a.id)
Models::Product.create(name: 'Product D', price: 12150.99, user_id: user_a.id)
Models::Product.create(name: 'Product E', price: 1500.99, user_id: user_a.id)
Models::Product.create(name: 'Product KK-1', price: 25.60, user_id: user_b.id)

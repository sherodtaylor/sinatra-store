require 'pry'
gem 'sinatra', '1.3.6'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

before do
   @db = SQLite3::Database.new "store.sqlite3"
   @db.results_as_hash = true
end

get '/users' do
  @rs = @db.prepare('SELECT * FROM users;').execute
  erb :show_users
end

get '/products' do
  @pr = @db.prepare('SELECT * FROM products;').execute
  erb :show_products
end

get '/' do
  erb :home
end

post '/new_product' do
  price = params[:product_price]
  name = params[:product_name]
  on_sale = params[:on_sale] 
  sql = "INSERT INTO products ('name','price','on_sale') VALUES ('#{name}', '#{price}','#{on_sale}')"
  @db.prepare(sql).execute
  erb :product_created
end

get "/new_product" do
   erb :create_product
end

get "/products/:product_id/edit" do
   @id = params[:product_id]
   sql = "Select * FROM products where id = #{@id};"
   row = @db.get_first_row(sql)
   @name = row['name']
   @price = row['price']
   erb :update_product
end

   # -- Edit User --
post "/products/:product_id/edit" do
 price = params[:product_price]
 name = params[:product_name]
 id = params[:product_id]
 sql = "UPDATE products SET name='#{name}', price=#{price} where id = #{id}"
 @rs = @db.prepare(sql).execute
 erb :update_success
end

## -- Individual User -- ##
get "/products/:product_id" do
   id = params[:product_id]
   sql = "Select * FROM products where #{id} = id;"
   @rs = @db.prepare(sql).execute
   erb :product_id
end



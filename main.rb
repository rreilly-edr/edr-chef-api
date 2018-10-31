#!/usr/bin/env ruby
require 'sinatra'
require 'chef-api'
require 'json'
require 'time'
include ChefAPI::Resource

conn = ChefAPI::Connection.new(
  endpoint: 'https://chef.edrcore.com/organizations/edr',
  client: 'admin',
  key: '/home/rreilly/.chef/admin.pem',
  ssl_verify: false
)
get '/:color' do
  puts params[:color]
  data = Hash.new()
  results = conn.search.query(:node, "hostname:*#{params[:color]}*")
  results.rows.each do |result|
    data["#{result['name']}"] = result['automatic']['ipaddress']
  end
  return data.to_json
end

get '/health' do
  content_type :json
  hlth = Hash.new()
  hlth["time"] = Time.now
  hlth["status"] = "ok"
  puts hlth
   hlth.to_json
end

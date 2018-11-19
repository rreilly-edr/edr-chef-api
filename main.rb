#!/usr/bin/env ruby
require 'sinatra'
require 'chef-api'
require 'json'
require 'time'
require 'chef'
include ChefAPI::Resource

#class MainBots < Sinatra::Base
  conn = ChefAPI::Connection.new(
    endpoint: 'https://chef.edrcore.com/organizations/edr',
    client: 'admin',
    key: '~/.chef/admin.pem',
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
    return hlth.to_json
  end

  get '/who/:whois' do 
    puts params[:who]
    data = Hash.new()
    # Setup connection to Chef Server
    Chef::Config.from_file('/home/rreilly/.chef/knife.rb')
    rest = Chef::ServerAPI.new(Chef::Config[:chef_server_url])
    # Fetch data bag
    results = rest.get_rest("/data/app_env/state")
    return results.to_json
  end
#end
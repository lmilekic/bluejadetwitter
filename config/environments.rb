require 'sinatra'
require 'sinatra/activerecord'
require 'erb'
require 'redis'

configure :production do
  puts "[production environment]"

  # as per Pito's example
  env = ENV["SINATRA_ENV"] || "production"
  databases = YAML.load(ERB.new(File.read("config/database.yml")).result)
  ActiveRecord::Base.establish_connection(databases[env])
end

configure :development do
  puts "[development environment]"
end

configure :test do
  puts "[test environment]"
end

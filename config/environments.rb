require 'sinatra'
require 'sinatra/activerecord'
require 'erb'

configure :production do
  puts "[production environment]"

  # as per Pito's example
  env = ENV["SINATRA_ENV"] || "production"
  databases = YAML.load(ERB.new(File.read("config/database.yml")).result)
  ActiveRecord::Base.establish_connection(databases[env])
end

configure :development, :test do
  puts "[development or test environment]"
end

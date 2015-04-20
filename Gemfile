source 'https://rubygems.org'
#if rubygems is down
#source 'http://production.cf.rubygems.org'
gem 'sinatra'

# Heroku can't install sqlite3, so have it use postgres
# => via http://stackoverflow.com/questions/13083399/heroku-deployment-failed-because-of-sqlite3-gem-error
group :development, :test do
  gem 'sqlite3'
end
group :production do
  gem 'pg'
end

gem 'sinatra-activerecord'
gem 'sinatra-flash'
gem "minitest"
gem 'rspec'
gem 'rack-test'
gem 'rake'
gem 'faker'
gem 'json'

gem 'newrelic_rpm'

# NEWWEB
gem 'puma'
gem 'foreman'

#REDIS
gem 'hiredis'
gem 'redis'

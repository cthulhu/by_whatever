ENV['RAILS_ENV'] = 'test'
ENV['RAILS_ROOT'] ||= File.dirname(__FILE__) + '/../../../..'

require 'rubygems'
require 'activerecord'
require 'test/unit'
require 'shoulda'

def load_schema
  
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/db/database.yml'))
  ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log") 

  raise "No DB Adapter selected" if (db_adapter = ENV['DB'] || 'sqlite3mem').nil?
  
  ActiveRecord::Base.establish_connection(config[db_adapter])
  
  load(File.dirname(__FILE__) + "/db/schema.rb")
  require File.dirname(__FILE__) + '/../init.rb'
  
end

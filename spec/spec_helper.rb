require "rubygems"
require "bundler"

Bundler.require(:default)

require 'active_support/all'

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each {|f| require f}

require File.expand_path(File.join(File.dirname(__FILE__), '../lib/acts_as_relatable'))

db_name = ENV['DB'] || 'sqlite3'
database_yml = File.expand_path('../database.yml', __FILE__)

if File.exists?(database_yml)
  ar_configuration = YAML.load_file(database_yml)
  ActiveRecord::Base.configurations = ar_configuration
  config = ActiveRecord::Base.configurations[db_name]

  begin
    ActiveRecord::Base.establish_connection(db_name)
    ActiveRecord::Base.connection
  rescue
    case db_name
    when /mysql/
      ActiveRecord::Base.establish_connection(config.merge('database' => nil))
      ActiveRecord::Base.connection.create_database(config['database'], {:charset => 'utf8', :collection => 'utf8_unicode_ci'})
    when /postgresql/
      ActiveRecord::Base.establish_connection(config.merge('database' => 'postgres', 'schema_search_path' => 'public'))
      ActiveRecord::Base.connection.create_database(config['database'], config.merge('encoding' => 'utf8'))
    end
    ActiveRecord::Base.establish_connection(config)
  end

  ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "../tmp/debug.log"))
  ActiveRecord::Base.default_timezone = :utc

  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false
    load(File.dirname(__FILE__) + '/schema.rb')
    load(File.dirname(__FILE__) + '/models.rb')
  end

else
  raise "Please create #{database_yml} first to configure your database. Take a look at: #{database_yml}.sample"
end

def clean_database!
  models = [Product, Shop, Tag]
  models.each do |model|
    ActiveRecord::Base.connection.execute "DELETE FROM #{model.table_name}"
  end
end

clean_database!
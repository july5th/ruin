require 'active_record'

ActiveRecord::Base.establish_connection(:adapter=>"mysql2", :host => "localhost", :database => "web_development", :username => "root")

require 'model/proxy.rb'


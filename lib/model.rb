require 'active_record'

ActiveRecord::Base.establish_connection(:adapter=>"sqlite3",:database=>"/root/ruin/web/db/development.sqlite3")

require 'model/proxy.rb'


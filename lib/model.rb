require 'active_record'

ActiveRecord::Base.establish_connection(:adapter=>"mysql2", :host => "localhost", :database => "web_development", :username => "root")

module RUIN
module MODEL

	autoload :Proxy, 'model/proxy'

end
end


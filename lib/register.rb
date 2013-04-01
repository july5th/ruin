require "headless"
headless = Headless.new(display:99)
headless.start
at_exit{ headless.destroy }

require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'

Capybara.run_server = false
Capybara.current_driver = :webkit

module RUIN
module REGISTER
	autoload :Sina, 'register/sina'
	autoload :WangYi163, 'register/wangyi163'
		
end
end

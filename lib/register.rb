require 'capybara'
require 'capybara/poltergeist'

Capybara.current_driver = :poltergeist

module RUIN
module REGISTER
	autoload :Sina, 'register/sina'
	autoload :WangYi163, 'register/wangyi163'
	autoload :Test, 'register/test'
	autoload :Base, 'register/base'
end
end

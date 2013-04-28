require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require 'capybara-screenshot'

include Capybara::DSL
Capybara.run_server = false
Capybara.current_driver = :webkit




module RUIN
module REGISTER

class Test
    include Capybara::DSL

    def initialize(host = nil, port = nil)
	@register_addr = "http://iframe.ip138.com/ic.asp"
	@isRegist = false
	if port and host then
		Capybara.register_driver :poltergeist do |app|
			options = {
				:phantomjs_options => [
					"--proxy=#{host}:#{port}"
					#"--load-images=no"
				]
			}
			Capybara::Poltergeist::Driver.new(app, options)
		end
	end

	page.driver.headers = { "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20100101 Firefox/18.0 Iceweasel/18.0.1" }
        visit(@register_addr)
    end

    def get_icode
	puts page.html
	page.save_screenshot('/root/3.png')
    end

end

end
end

# encoding: utf-8

module RUIN
module REGISTER

class Base
    include Capybara::DSL

    def initialize(host = nil, port = nil)
	@logger = RUIN::UTIL::LogUtils.instance
	@plung_name = "undefined" unless @plung_name
	@isRegist = false
	if port and host then
		Capybara.register_driver :poltergeist do |app|
			options = {
				:phantomjs_options => [
					"--proxy=#{host}:#{port}"
					#"--proxy-type=http"
					#"--load-images=no"
				]
			}
			Capybara::Poltergeist::Driver.new(app, options)
		end
	end
	page.driver.headers = { "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64; rv:18.0) Gecko/20100101 Firefox/18.0 Iceweasel/18.0.1" }
	if @register_addr then 
		@logger.info("#{@plung_name}: visit #{@register_addr} with proxy #{host}: #{port}")
		visit(@register_addr)
	end
    end

    def get_icode
	@icode_filename = RUIN::CONFIG::ICodeDir + RUIN::UTIL::RandomUtils.get_char_and_number(12) + ".png"
	page.save_screenshot(@icode_filename)
	RUIN::UTIL::ImageUtils.cut(@icode_filename, @x, @y, @icode_width, @icode_height)
	@icode_filename
    end

    def re_get_icode
	page.find_by_id("vcodeImg").click
	sleep(5) 
	page.save_screenshot(@icode_filename)
	RUIN::UTIL::ImageUtils.cut(@icode_filename, @x, @y, @icode_width, @icode_height)	
    end

    def register(icode)
    end

    def check_by_login
	begin
		@logger.info("#{@plung_name}: start check with #{@username} : #{@password}")
		if RUIN::EMAIL::Email.try_login(@username, @password, @email_type) then 
			@logger.info("check pass for #{@username} : #{@password}")
			return true 
		end
        rescue => err
		@logger.info("#{@plung_name}: check false for #{@username} : #{@password}")
                return false
        end
    end

    def save
        e = RUIN::MODEL::Email.new
        e.username = @username
        e.password = @password
        e.etype_id = @email_type if @email_type 
        e.check = 0
        e.save
        @id = e.id
    end

end

end
end

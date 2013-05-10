# encoding: utf-8

module RUIN
module REGISTER

class WangYi163 < RUIN::REGISTER::Base
    include Capybara::DSL

    def initialize(host = nil, port = nil)
	@plung_name = "mail163"
	@email_type = RUIN::CONFIG::MailType_163
	@register_addr = "http://reg.email.163.com/unireg/call.do?cmd=register.entrance"
	@x = 390
	@y = 460
	@icode_width = 122
	@icode_height = 52
	super(host, port)
	page.find(:xpath, "//a[@class='a1']").click
	page.save_screenshot("/root/t.png")
    end

    def register(icode)
	loop_time = 0
	loop do
		is_right = true
		@username = RUIN::UTIL::RandomUtils.get_chars(2 + rand(3)).downcase + "_" + RUIN::UTIL::RandomUtils.get_numbers(4 + rand(4))
		@password = RUIN::UTIL::RandomUtils.get_char_and_number(12)
		page.evaluate_script("document.getElementById(\"nameIpt\").focus();")
		page.evaluate_script("document.getElementById(\"nameIpt\").click();")
		page.find_by_id("nameIpt").set @username
		page.evaluate_script("document.getElementById(\"nameIpt\").blur();")
		page.evaluate_script("document.getElementById(\"mainPwdIpt\").focus();")
		while not page.has_xpath?("//html/body/section/div/div[2]/div[3]/dl/dd/div[2]/span/b") do 
			if page.has_xpath?("//html/body/section/div/div[2]/div[3]/dl/dd/div[2]/div[2]") or loop_time >= 3 then
				is_right = false
				break
			end
			loop_time += 1
			@logger.info("wait for ajax")
		end
		next unless is_right
		page.evaluate_script("document.getElementById(\"mainPwdIpt\").click();")
		page.find_by_id("mainPwdIpt").set @password
		page.evaluate_script("document.getElementById(\"mainCfmPwdIpt\").focus();")
		page.evaluate_script("document.getElementById(\"mainCfmPwdIpt\").click();")
		page.find_by_id("mainCfmPwdIpt").set @password
		page.evaluate_script("document.getElementById(\"vcodeIpt\").focus();")
		page.evaluate_script("document.getElementById(\"vcodeIpt\").click();")
		page.find_by_id("vcodeIpt").set icode
		page.evaluate_script("document.getElementById(\"vcodeIpt\").blur();")
		#fill_in "vcode", :with => icode
		#break if check
		break if is_right
		@logger.info("loop for check 163")
	end
	loop_time = 0
	page.find_by_id("mainRegA").click
	@logger.info("try to regist with #{@username} : #{@password}")
	result = check_final
	while not result do
		sleep(1)
		loop_time += 1
		break if loop_time > 3
		@logger.info("loop for result 163")
		begin
			page.find_by_id("mainRegA").click
		rescue => err
			break
		end
		result = check_final
	end


	if result == 2 or result == 3 then
		@logger.info("something wrong..")
	else
		if check_by_login then 
			save
			result = 1
		end
	end
	page.save_screenshot("/root/1.png")
	return result
    end

    def check_final
	if page.has_xpath?("/html/body/section/div/div[2]/div[3]/dl[4]/dd/div[2]/span/b") then return 2 end
	if page.has_xpath?("//*[@id=\"fskipA\"]") then return 1 end
	if page.has_xpath?("//*[@id=\"gshiftA\"]") then return 3 end
	return false
    end

    def check
	begin
		return false if page.find_by_id('conflictDiv').visible?
	rescue => err
		return true
	end
    end

end

end
end

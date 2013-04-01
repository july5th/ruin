module RUIN
module REGISTER

class WangYi163
    def initialize
	@register_addr = "http://reg.email.163.com/unireg/call.do?cmd=register.entrance&from=163navi&regPage=163"
    end

    include Capybara::DSL
fill_in "q", :with => ARGV[0] || "I love Ruby!"

page.find_by_id("nameIpt").set "asdfwqerf"
page.find_by_id("mainPwdIpt").set "111111aaa"
page.find_by_id("mainCfmPwdIpt").set "111111aaa"
page.find_by_id("vcodeIpt")
page.find_by_id("vcodeImg")[:src]
page.find_by_id("mainRegA").click   
    def search
        visit(@register_addr)
        puts body
    end
end

end
end

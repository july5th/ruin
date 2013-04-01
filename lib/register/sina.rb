module RUIN
module REGISTER

class Sina
    def initialize
	@register_addr = "https://login.sina.com.cn/signup/signup.php?entry=freemail"
    end

    include Capybara::DSL
    
    def search
        visit(@register_addr)
        puts body
    end
end

end
end

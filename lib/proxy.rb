require 'mechanize'

require 'ruin_base'

module RUIN
module PROXY

class HttpProxy

    def initialize(level = 6, time_out = RUIN::CONFIG::ProxyMaxTimeOut)
	@agent = Mechanize.new
	@agent.user_agent_alias = 'Windows IE 7'
	@level = level
	@time_out = time_out
    end

    def self.get_proxy(level = 6, time_out = RUIN::CONFIG::ProxyMaxTimeOut)
	num = (10 - level) * RUIN::MODEL::Proxy.all.count / 10
	proxy_list = RUIN::MODEL::Proxy.limit(num).order('level desc')
	id = rand(proxy_list.count - 1)
	ip = proxy_list[id].ip
	port = proxy_list[id].port
	return {:ip => ip, :port => port}
    end

    def set_proxy(ip = nil, port = nil)
	if ip and port then
		@ip = ip
		@port = port
	else
		num = (10 - @level) * RUIN::MODEL::Proxy.all.count / 10
		@proxy_list = RUIN::MODEL::Proxy.limit(num).order('level desc')
		id = rand(@proxy_list.count - 1)
		@ip = @proxy_list[id].ip
		@port = @proxy_list[id].port
	end
	@agent.set_proxy(@ip, @port)
    end

    def reset_proxy()
	set_proxy
    end

    def get_url(url)
	@agent.get(url)
    end

    def get_url_auto_change_proxy(url)
	begin
		Timeout::timeout(@time_out){@agent.get(url)}
	rescue => err
		reset_proxy
		retry
	end
    end

    def get_agent()
	@agent
    end

    def test()
	set_proxy
	puts "set proxy : #{@ip} : #{@port}"
	set_proxy("10.10.10.10", "8888")
	puts "set proxy : #{@ip} : #{@port}"
	set_proxy("10.10.10.10")
	puts "set proxy : #{@ip} : #{@port}"
    end
end

end
end

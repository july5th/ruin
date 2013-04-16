require 'mechanize'
require 'logger'
require 'util/iputils'

module RUIN
module PROXY

class HttpProxy

    def initialize()
	@logger = Logger.new(STDOUT)
	@logger.info("Init http proxy module.")
    	@check_ip_addr = "http://iframe.ip138.com/ic.asp"
	@agent = Mechanize.new
    	@proxy_ip_hash = {}
	@real_ip = get_real_ip()
	@time_out = 10
	@final_proxy_ip_hash = {}
    end

    def init_http_proxy()
	@logger.info("Starting collect http proxy IP...")
	init_http_proxy_from_51proxy()
	@logger.info("End collect http proxy IP... NUM:" + @proxy_ip_hash.count.to_s)
    end
	
    def init_http_proxy_from_51proxy()
	@logger.info("Start collect http proxy IP from 51proxy...")
	begin
		content = @agent.get("http://51dai.li/http_anonymous.html")
		content.root.search('table/tr').each {|e| 
			proxy_ip_list = e.text.gsub(/\t/,'').strip.split("\n")
			if proxy_ip_list.count == 4 then
				@logger.info(proxy_ip_list.join("=>"))
				store_proxy_hash(proxy_ip_list[1], proxy_ip_list[2], proxy_ip_list[3])
			end
		}
	rescue => err
		@logger.error("Some error happend when collect http proxy IP from 51proxy...")
		@logger.error(err)
	end
    end

    def store_proxy_hash(ip, port, addr, addtion = 0)
	if (!ip || !port ) then return end
	if (!RUIN::UTIL::IpUtils.check_ip_format(ip)) then
		ip = RUIN::UTIL::IpUtils.get_ip_from_dns(ip)
		if(!ip) then return end
	end
	if (@proxy_ip_hash.has_key?(ip)) then return end
	@proxy_ip_hash.store(ip, {:port=> port, :addr=> addr, :addtion=> addtion})
    end

    def get_proxy_hashnum
	@proxy_ip_hash.count
    end

    def print_proxy
	@proxy_ip_hash.each_key { |p| puts p + ":" + @proxy_ip_hash[p][:port] }
    end

    def check_proxy
	"wait"
    end

    def change_proxy
	@agent.set_proxy('122.72.2.180', '8080')
    end

    def get_real_ip()
        @agent.get(@check_ip_addr).search("body").text.scan(/\d+/).join(".")
    end

    def self.get_real_ip(agent)
        agent.get(@check_ip_addr).search("body").text.scan(/\d+/).join(".")
    end

    def store_proxy_ip_to_file(file_name)
	"wait"
    end
end

end
end


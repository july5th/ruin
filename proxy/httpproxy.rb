require 'mechanize'
require 'logger'
require 'util/iputils'
require 'util/logutils'

module RUIN
module PROXY

class HttpProxy

    def initialize()
	@logger = RUIN::UTIL::Logutils.instance
	@logger.info("Init http proxy module.")
    	@check_ip_addr = "http://iframe.ip138.com/ic.asp"
	@agent = Mechanize.new
	@test_agent = Mechanize.new
    	@proxy_ip_hash = {}
	@real_ip = get_real_ip()
	@time_out = 3
	@final_proxy_hash = {}
    end

    def init_http_proxy()
	@logger.info("Starting collect http proxy IP...")
	init_http_proxy_from_51proxy()
	@logger.info("Starting check proxy ip!")
	check_proxy(@proxy_ip_hash)
	@logger.info("End collect http proxy IP... NUM:" + @proxy_ip_hash.count.to_s)
    end
	
    def init_http_proxy_from_51proxy()
	@logger.info("Start collect http proxy IP from 51proxy...")
	begin
		content = @agent.get("http://51dai.li/http_anonymous.html")
		content.root.search('table/tr').each {|e| 
			proxy_ip_list = e.text.gsub(/\t/,'').strip.split("\n")
			if proxy_ip_list.count == 4 then
				return if proxy_ip_list[0].to_i > 30
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
	return unless ip
	return unless port
	if (!RUIN::UTIL::IpUtils.check_ip_format(ip)) then
		ip = RUIN::UTIL::IpUtils.get_ip_from_dns(ip)
		return unless ip
	end
	return if @proxy_ip_hash.has_key?(ip)
	@proxy_ip_hash.store(ip, {:port=> port, :addr=> addr, :addtion=> addtion})
    end

    def get_proxy_hashnum
	@proxy_ip_hash.count
    end

    def print_proxy
	@proxy_ip_hash.each { |ip, content| puts ip + ":" + content[:port] }
    end

    def check_proxy(proxy_hash)
	proxy_hash.each { |ip, content| proxy_hash.delete(ip) unless check_proxy_func(ip, content[:port]) }
    end

    def check_proxy_func(ip, port)
	begin
		@logger.info("Check proxy ip [ip:port] : " + ip.to_s + ":" + port.to_s)
		return false unless RUIN::UTIL::IpUtils.check_ip_connection(ip, port, @time_out)
		change_proxy(ip, port)
		return false if Timeout::timeout(@time_out){get_real_ip != ip}
		return true
	rescue Timeout::Error
		return false
	rescue => err
		@logger.error("Some error happend when check [ip:port] : " + ip.to_s + ":" + port.to_s)
                @logger.error(err)
		return false
	end
    end

    def add_proxy_to_final
	@proxy_ip_hash.each { |ip, content| @final_proxy_hash.store(ip, content) unless @final_proxy_hash. }
    end

    def change_proxy(ip, port)
	@agent.set_proxy(ip, port)
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


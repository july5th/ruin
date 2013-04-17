require 'mechanize'
require 'logger'
require "thread"

require 'util/ip_utils'
require 'util/log_utils'

module RUIN
module PROXY

class HttpProxy

    def initialize()
	@logger = RUIN::UTIL::Logutils.instance
	@logger.info("Init http proxy module.")
	@check_ip_addr = "http://iframe.ip138.com/ic.asp"
	@agent = Mechanize.new
	@proxy_dns_hash = {}
	@proxy_ip_hash = {}
	@real_ip = get_real_ip(@agent)
	@time_out = 3
	@proxy_dns_hash_mutex = Mutex.new
	@proxy_ip_hash_mutex = Mutex.new

    end

    def init_http_proxy()
	@logger.info("Starting collect http proxy IP...")
	init_http_proxy_from_51proxy()
	@logger.info("Starting check proxy ip!")
	check_proxy
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
				store_dns_hash(proxy_ip_list[1], proxy_ip_list[2], proxy_ip_list[3])
			end
		}
	rescue => err
		@logger.error("Some error happend when collect http proxy IP from 51proxy...")
		@logger.error(err)
	end
    end

    def store_dns_hash(ip, port, addr, addtion = 0)
	return unless ip
	return unless port
	return if @proxy_dns_hash.has_key?(ip)
	@proxy_dns_hash.store(ip, {:port=> port, :addr=> addr, :addtion=> addtion})
    end

    def get_proxy_hashnum
	@proxy_ip_hash.count
    end

    def print_proxy
	@proxy_ip_hash.each { |ip, content| puts ip + ":" + content[:port] }
    end

    def check_proxy()
	ts = []
	0.upto(10){
		puts "start thread"
		ts<<Thread.start {
		puts "start thread"
		agent = Mechanize.new
		while true
			ip = nil
			content = nil
			@proxy_dns_hash_mutex.synchronize {
				ip, content = @proxy_dns_hash.shift
			}
			Thread.exit unless ip
			Thread.exit unless content
			puts ip + ":" + content[:port].to_s + " left:" + @proxy_dns_hash.count.to_s
			if (!RUIN::UTIL::IpUtils.check_ip_format(ip)) then
				ip = RUIN::UTIL::IpUtils.get_ip_from_dns(ip)
				puts "start thread4" unless ip
				next unless ip
			end
			next if @proxy_ip_hash.has_key?(ip)
			next unless check_proxy_func(ip, content[:port], agent)
			@proxy_ip_hash_mutex.synchronize {
				@proxy_ip_hash.store(ip, {:port=> content[:port], :addr=> content[:addr], :addtion=> content[:addtion]})
			}
		end
		}
	}
	ts.flatten.each(&:join)
    end

    def check_proxy_func(ip, port, agent)
	begin
		@logger.info("Check proxy ip [ip:port] : " + ip.to_s + ":" + port.to_s)
		return false unless RUIN::UTIL::IpUtils.check_ip_connection(ip, port, @time_out)
		agent.set_proxy(ip, port)
		return false if Timeout::timeout(@time_out){get_real_ip(agent) != ip}
		return true
	rescue Timeout::Error
		return false
	rescue => err
		@logger.error("Some error happend when check [ip:port] : " + ip.to_s + ":" + port.to_s)
                @logger.error(err)
		return false
	end
    end

    def get_real_ip(agent)
        agent.get(@check_ip_addr).search("body").text.scan(/\d+/).join(".")
    end

    def store_proxy_ip(file_name)
	"wait"
    end
end

end
end


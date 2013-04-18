require 'mechanize'
require 'logger'
require "thread"

require 'util/ip_utils'
require 'util/log_utils'

require 'ruin_base'

module RUIN
module PROXY

class HttpProxy

    def initialize()
	@logger = RUIN::UTIL::Logutils.instance
	@logger.info("Init http proxy module.")
	@check_ip_addr = "http://iframe.ip138.com/ic.asp"
	@agent = Mechanize.new
	@tmp_ip_hash = {}
	@old_ip_hash = {}
	@old2_ip_hash = {}
	@ip_hash = {}
	@real_ip = get_real_ip(@agent)
	@time_out = 5
	@tmp_ip_hash_mutex = Mutex.new
	@ip_hash_mutex = Mutex.new

    end

    def run()
	@logger.info("Starting check old http proxy IP...")
	load_old_proxy
	if @tmp_ip_hash.count > 0 then
		check_proxy
		@logger.info("Check old proxy #{@old_ip_hash.count}, #{@ip_hash.count} is alive")
		del_old_proxy
	end
	@logger.info("Starting collect new http proxy IP...")
	add_http_proxy
	@logger.info("New http proxy ip num: #{@ip_hash.count}")
    	print_proxy
    end

    def add_http_proxy()
	init_http_proxy_from_51proxy()
	@logger.debug("Starting check proxy ip!")
	check_proxy
	@logger.debug("End collect http proxy IP... NUM:" + @ip_hash.count.to_s)
	store_proxy_ip
    end
	
    def init_http_proxy_from_51proxy()
	@logger.debug("Start collect http proxy IP from 51proxy...")
	begin
		content = @agent.get("http://51dai.li/http_anonymous.html")
		content.root.search('table/tr').each {|e| 
			proxy_ip_list = e.text.gsub(/\t/,'').strip.split("\n")
			if proxy_ip_list.count == 4 then
				@logger.debug(proxy_ip_list.join("=>"))
				store_tmp_ip_hash(proxy_ip_list[1], proxy_ip_list[2])
			end
		}
	rescue => err
		@logger.error("Some error happend when collect http proxy IP from 51proxy...")
		@logger.error(err)
	end
    end

    def store_tmp_ip_hash(ip, port)
	return unless ip
	return unless port
	return if @tmp_ip_hash.has_key?(ip)
	return if @old2_ip_hash.has_key?(ip)
	@tmp_ip_hash.store(ip, port)
    end

    def check_proxy()
	ts = []
	0.upto(RUIN::CONFIG::ProxyMaxThread){
		ts<<Thread.start { |x|
		@logger.debug("start check thread : #{x}")
		agent = Mechanize.new
		while true
			ip = nil
			port = nil
			@tmp_ip_hash_mutex.synchronize {
				ip, port = @tmp_ip_hash.shift
			}
			Thread.exit unless ip
			Thread.exit unless port
			@logger.debug("check #{ip} : #{port} left: #{@tmp_ip_hash.count.to_s}")
			if (!RUIN::UTIL::IpUtils.check_ip_format(ip)) then
				ip = RUIN::UTIL::IpUtils.get_ip_from_dns(ip)
				next unless ip
			end
			next if @ip_hash.has_key?(ip)
			next if @old2_ip_hash.has_key?(ip)
			next unless check_proxy_func(ip, port, agent)
			@ip_hash_mutex.synchronize {
				@ip_hash.store(ip, port)
			}
		end
		}
	}
	ts.flatten.each(&:join)
    end

    def check_proxy_func(ip, port, agent)
	begin
		return false unless RUIN::UTIL::IpUtils.check_ip_connection(ip, port, @time_out)
		agent.set_proxy(ip, port)
		return false if Timeout::timeout(@time_out){get_real_ip(agent) != ip}
		return true
	rescue Timeout::Error
		return false
	rescue => err
		@logger.error("Some error happend when check #{ip}:#{port}")
                @logger.error(err)
		return false
	end
    end

    def get_real_ip(agent)
        agent.get(@check_ip_addr).search("body").text.scan(/\d+/).join(".")
    end

    def load_old_proxy()
	RUIN::MODEL::Proxy.all.each { |p|
                @logger.info("Load old proxy: #{p.ip} : #{p.port}")
		@tmp_ip_hash.store(p.ip, p.port)
		@old_ip_hash.store(p.ip, p.port)
        }
    end

    def del_old_proxy()
	@old_ip_hash.each { |ip, port| 
		if not @ip_hash.has_key?(ip) then
			@logger.info("Delete old proxy: #{ip} : #{port}")
			RUIN::MODEL::Proxy.find_by_ip(ip).delete
		end
	}
	@old2_ip_hash.clear
	@ip_hash.each { |ip, port| 
		@old2_ip_hash.store(ip, port)
	}
	@ip_hash.clear
    end

    def store_proxy_ip()
	@ip_hash.each { |ip, port| 
		@logger.info("Add new proxy: #{ip} : #{port}")
		p = RUIN::MODEL::Proxy.new
		p.ip = ip
		p.port = port
		p.save
	}
    end

    def print_proxy()
	RUIN::MODEL::Proxy.all.each { |p|
                puts "final proxy : #{p.ip}:#{p.port}"
        }
    end

end

end
end


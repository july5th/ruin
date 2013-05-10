require 'mechanize'
require "thread"
require 'find'
require 'ruin_base'

module RUIN
module DAEMON

class HttpProxy

    def initialize()
	@logger = RUIN::UTIL::LogUtils.instance
	@logger.info("Init http proxy module.")
	@check_ip_addr = "http://iframe.ip138.com/ic.asp"
	@agent = Mechanize.new
	@tmp_ip_hash = {}
	@old_ip_hash = {}
	@old2_ip_hash = {}
	@ip_hash = {}
	@https_hash = {}
	@real_ip = get_real_ip(@agent)
	@time_out = RUIN::CONFIG::ProxyMaxTimeOut
	@tmp_ip_hash_mutex = Mutex.new
	@ip_hash_mutex = Mutex.new
	load_plugins
    end

    def load_plugins
	plugins_path = File.expand_path(File.join(File.dirname(__FILE__) , 'proxy'))
	Find.find(plugins_path) {|x| require x if File.file?(x)}
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
	clear
    end


    def add_http_proxy()
	self.methods.grep(/init_http_proxy_from/).each { |method| self.send method }
	@logger.debug("Starting check proxy ip!")
	check_proxy
	@logger.debug("End collect http proxy IP... NUM:" + @ip_hash.count.to_s)
	store_proxy_ip
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
	0.upto(RUIN::CONFIG::ProxyDaemonMaxThread){
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
			result = check_proxy_func(ip, port, agent)
			next unless result
			@ip_hash_mutex.synchronize {
				@ip_hash.store(ip, port)
				@https_hash.store(ip, port) if result == "https"
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
	rescue Timeout::Error
		return false
	rescue => err
		@logger.error("Some error happend when check #{ip}:#{port}")
		return false
	end

	begin
		Timeout::timeout(@time_out){check_if_https(agent)}
		return "https"
	rescue => err
		return "http"
	end
    end

    def get_real_ip(agent)
        agent.get(@check_ip_addr).search("body").text.scan(/\d+/).join(".")
    end

    def check_if_https(agent)
	agent.get("https://www.battlenet.com.cn/account/creation/tos.html")
    end

    def load_old_proxy()
	RUIN::MODEL::Proxy.all.each { |p|
		if @tmp_ip_hash.has_key?(p.ip) then
			p.delete
		else
                	@logger.info("Load old proxy: #{p.ip} : #{p.port}")
			@tmp_ip_hash.store(p.ip, p.port)
			@old_ip_hash.store(p.ip, p.port)
		end
        }
    end

    def del_old_proxy()
	@old_ip_hash.each { |ip, port| 
		if not @ip_hash.has_key?(ip) then
			p = RUIN::MODEL::Proxy.find_by_ip(ip)
			if p.level <= 0 or p.error >=3 then
				@logger.info("Delete old proxy: #{ip} : #{port}")
				p.delete
			else
				p.error += 1
				p.level -= 1
				@logger.info("Down proxy level: #{ip} : #{port} To #{p.level}(#{p.error})")
				p.save
			end
		else
			p = RUIN::MODEL::Proxy.find_by_ip(ip)
			p.level += 1
			p.error = 0
			p.https = 1 if @https_hash.has_key?(ip)
			p.save
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
		p.level = 0
		p.error = 0
		p.https = 1 if @https_hash.has_key?(ip)
		p.save
	}
    end

    def print_proxy()
	RUIN::MODEL::Proxy.all.each { |p|
                puts "final proxy : #{p.ip}:#{p.port}"
        }
    end

    def clear()
	@tmp_ip_hash.clear
        @old_ip_hash.clear
        @old2_ip_hash.clear
	@https_hash.clear
    end
end

end
end


require 'resolv'
require 'util/log_utils'

module RUIN
module UTIL

class IpUtils

    def self.check_ip_format(ip_str)
	reg = /^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$/
	ip_str.match(reg)
    end

    def self.check_ip_connection(ip, port, time_out)
	begin
		Timeout::timeout(time_out){TCPSocket.new(ip, port)}
		return true
	rescue Timeout::Error
		return false
	rescue => err
		RUIN::UTIL::Logutils.error(err)
		return false
	end
    end

    def self.get_ip_from_dns(domain_str)
	ip_list = Array.new
	Resolv::DNS.new.each_address(domain_str) {|addr| ip_list.push(addr)}
	if ip_list.count == 1 then
		return ip_list[0].to_s
	else
		return nil
	end
    end
end

end
end


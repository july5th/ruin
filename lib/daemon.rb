require "thread"
require "config"
require "daemon/proxy_daemon"

module RUIN
module DAEMON

class Daemon

    def initialize()
	@daem_list = []
	@daem_list << RUIN::DAEMON::HttpProxy.new
    end

    @@instance = Daemon.new

    def self.instance
	return @@instance
    end

    def run()
	p_list = []
	@daem_list.each {|daem| 
		p_list << Thread.start {
			daem.run()
		}
	}
	p_list.flatten.each(&:join)
    end

    def self.run
	loop do
		Daemon.instance.run
		sleep(RUIN::CONFIG::DaemonSleepTime)
	end
    end
end

end
end

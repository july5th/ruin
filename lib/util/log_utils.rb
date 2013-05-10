require 'logger'

module RUIN
module UTIL

class LogUtils

    def initialize
	@logger = Logger.new(STDOUT)
    end

    @@instance = LogUtils.new
  
    def self.instance
	return @@instance
    end

    def info(msg)
	@logger.info(msg)
    end

    def error(msg)
	#@logger.error(msg)
    end

    def debug(msg)
	@logger.debug(msg)
    end

    def self.info(msg)
	LogUtils.instance.info(msg)
    end

    def self.error(msg)
	LogUtils.instance.error(msg)
    end

    def self.debug(msg)
	LogUtils.instance.debug(msg)
    end

end

end
end

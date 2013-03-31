require 'logger'

module RUIN
module UTIL

class Logutils

    def initialize
	@logger = Logger.new(STDOUT)
    end

    @@instance = Logutils.new
  
    def self.instance
	return @@instance
    end

    def info(msg)
	@logger.info(msg)
    end

    def error(msg)
	@logger.error(msg)
    end

    def self.info(msg)
	Logutils.instance.info(msg)
    end

    def self.error(msg)
	Logutils.instance.error(msg)
    end

end

end
end

#!/usr/bin/env ruby
# -*- coding: binary -*-

ruinbase = __FILE__
while File.symlink?(ruinbase)
        ruinbase = File.expand_path(File.readlink(ruinbase), File.dirname(ruinbase))
end

@ruinbase_dir = File.dirname(ruinbase)
$:.unshift(File.expand_path(File.join(File.dirname(@ruinbase_dir) , 'lib')))

require "ruin_base"
proxy = RUIN::PROXY::HttpProxy.new()

#loop do
	proxy.set_proxy("127.0.0.1", "8118")
	puts proxy.get_url("http://iframe.ip138.com/ic.asp").search("body").text.scan(/\d+/).join(".")
#end


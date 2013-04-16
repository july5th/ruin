#!/usr/bin/env ruby
# -*- coding: binary -*-

ruinbase = __FILE__
while File.symlink?(ruinbase)
        ruinbase = File.expand_path(File.readlink(ruinbase), File.dirname(ruinbase))
end

@ruinbase_dir = File.expand_path(File.dirname(ruinbase))

$:.unshift(@ruinbase_dir)

require "proxy/httpproxy"


p = RUIN::PROXY::HttpProxy.new
p.init_http_proxy()
p.print_proxy


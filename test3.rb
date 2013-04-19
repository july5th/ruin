#!/usr/bin/env ruby
# -*- coding: binary -*-

ruinbase = __FILE__
while File.symlink?(ruinbase)
        ruinbase = File.expand_path(File.readlink(ruinbase), File.dirname(ruinbase))
end

@ruinbase_dir = File.dirname(ruinbase)
$:.unshift(File.expand_path(File.join(File.dirname(@ruinbase_dir) , 'lib')))

require "ruin_base"
require "daemon"

#RUIN::DAEMON::HttpProxy.new

   def init_http_proxy_from_51proxy()
        @logger.debug("Start collect http proxy IP from 51proxy...")
        rt = 0
        begin
                content = @agent.get("http://51dai.li/http_anonymous.html")
        rescue => err
                rt += 1
                if rt > 3 then
                        @logger.error("Error load proxy from http://51dai.li/http_anonymous.html return")
                        return
                end
                @logger.error("Error load proxy from http://51dai.li/http_anonymous.html, retry:#{rt} times")
                sleep(3)
                retry
        end
        begin
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

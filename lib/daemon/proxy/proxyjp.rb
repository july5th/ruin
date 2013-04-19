module RUIN
module DAEMON

class HttpProxy

    def init_http_proxy_from_proxyjp()
        @logger.debug("Start collect http proxy IP from proxy.jp ...")
        rt = 0
        1.upto(5) { |x|
                begin
                        content = @agent.get("http://www.getproxy.jp/en/china/#{x}")
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
                rt = 0
                begin
                        content.root.search('table/tr').each {|e|
                                proxy_ip_list = e.text.split("\r")[0].split(":")
                                if proxy_ip_list.count == 2 then
                                        @logger.debug(proxy_ip_list.join("=>"))
                                        store_tmp_ip_hash(proxy_ip_list[0], proxy_ip_list[1])
                                end
                        }
                rescue => err
                        @logger.error("Some error happend when collect http proxy IP from proxy.jp...")
                        @logger.error(err)
                end
        }
    end
end

end
end

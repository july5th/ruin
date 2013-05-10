#!/usr/bin/env ruby
# encoding: utf-8

ruinbase = __FILE__
while File.symlink?(ruinbase)
        ruinbase = File.expand_path(File.readlink(ruinbase), File.dirname(ruinbase))
end

@ruinbase_dir = File.dirname(ruinbase)
$:.unshift(File.expand_path(File.join(File.dirname(@ruinbase_dir) , 'lib')))

require "ruin_base"

#proxy = RUIN::PROXY::HttpProxy.get_proxy

#@c = RUIN::REGISTER::WangYi163.new("127.0.0.1", "8118")
@c = RUIN::REGISTER::WangYi163.new("114.80.209.78", "80")
#@c = RUIN::REGISTER::WangYi163.new()
def put_icode
	puts @c.get_icode
	icode = gets.chomp()
	while icode == "re" do
		@c.re_get_icode 
		icode = gets.chomp()
	end
	icode
end

result = @c.register(put_icode)

while result == 2 do
	result = @c.register(put_icode)
end


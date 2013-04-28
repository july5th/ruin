#!/usr/bin/env ruby
# -*- coding: binary -*-

ruinbase = __FILE__
while File.symlink?(ruinbase)
        ruinbase = File.expand_path(File.readlink(ruinbase), File.dirname(ruinbase))
end

@ruinbase_dir = File.dirname(ruinbase)
$:.unshift(File.expand_path(File.join(File.dirname(@ruinbase_dir) , 'lib')))

require "ruin_base"
puts RUIN::MODEL::Email.save2("onf_558483", "IOa6LtT19flI")
#puts RUIN::EMAIL::Email.try_login(2)

#!/usr/bin/env ruby
# -*- coding: binary -*-

ruinbase = __FILE__
while File.symlink?(ruinbase)
        ruinbase = File.expand_path(File.readlink(ruinbase), File.dirname(ruinbase))
end

@ruinbase_dir = File.dirname(ruinbase)
$:.unshift(File.expand_path(File.join(File.dirname(@ruinbase_dir) , 'lib')))

require "ruin_base"
e = RUIN::MODEL::Email.get()
#e.username = "onf_558481"
#e.password = "IOa6LtT19flI"
#e.etype_id = 1
#e.check = 0
#e.save

require 'logger'
require 'net/pop'
require "base64"

module RUIN
module UTIL

class EmailUtils
    def self.decode_subject(email)
	sub = email.header.split("\r\n").grep(/^Subject:/).to_s
	if sub.include?("B?")
		encode_str = sub.match(/=\?(.*?)\?=/).to_s
		encode_str.scan(/=\?(.*?)\?(B\?)(.*?)\?=/)
		if $1 != nil
			encode = $1.to_s
			if encode == 'utf8'
				encode = 'utf-8'
			end
			str = $3.to_s
			decode_str = Base64.decode64(str).force_encoding(encode).encode("utf-8")
			return decode_str
		else 
			return $3
		end
	else
		return sub
	end
    end

end


end
end

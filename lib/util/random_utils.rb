module RUIN
module UTIL

class RandomUtils

    def self.get_chars(len = nil)
	len = 8 + rand(5) unless len
	chars = ("a".."z").to_a + ("A".."Z").to_a
	newpass = ""
	1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
	return newpass
    end

    def self.get_numbers(len = nil)
	len = 8 + rand(5) unless len
	newpass = ""
	1.upto(len){ |i| newpass << rand(10).to_s}
	return newpass
    end

    def self.get_char_and_number(len = nil)
	len = 8 + rand(5) unless len
	chars = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a
	newpass = ""
	1.upto(len) { |i| newpass << chars[rand(chars.size - 1)] }
	return newpass
    end

end

end
end

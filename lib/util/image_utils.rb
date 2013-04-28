require 'RMagick'

module RUIN
module UTIL

class ImageUtils

    def self.cut(file_name, x, y, width, height)
	img = Magick::Image.read(file_name).first
	img.crop!(x, y, width, height)
	img.write(file_name)
    end

end

end
end


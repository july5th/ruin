module RUIN
module MODEL

class Email < ActiveRecord::Base
	belongs_to :emailtype, {:foreign_key => "etype_id"}

	def self.save2(username, password)
		e = RUIN::MODEL::Email.new
		e.username = username
		e.password = password
		e.etype_id = 1
		e.check = 0
		e.save
		return e.id
	end
end

end
end


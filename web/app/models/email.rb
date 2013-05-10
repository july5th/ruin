class Email < ActiveRecord::Base
  # attr_accessible :title, :body
	belongs_to :emailtype, {:foreign_key => "etype_id"}
end

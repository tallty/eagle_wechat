class Interface < ActiveRecord::Base
	belongs_to :customer

	after_initialize :generate_identifier

	def generate_identifier
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		self.identifier ||= chars.sample(8).join
	end  
end

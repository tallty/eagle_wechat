# == Schema Information
#
# Table name: interfaces
#
#  id          :integer          not null, primary key
#  identifier  :string(255)
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#

class Interface < ActiveRecord::Base
	belongs_to :customer

	after_initialize :generate_identifier

	def generate_identifier
		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
		self.identifier ||= chars.sample(8).join
	end
end

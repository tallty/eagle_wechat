# == Schema Information
#
# Table name: interfaces_api_users
#
#  id           :integer          not null, primary key
#  interface_id :integer
#  api_user_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class InterfacesApiUser < ActiveRecord::Base
	belongs_to :interface
	belongs_to :api_user

	# 保存指定接口的所有调用客户
	def self.save_interface_api_users(interface_id, api_users)
		create_api_users = api_users.to_a
		InterfacesApiUser.transaction do
			unless create_api_users.empty?
				create_api_users.each do |api_user_id|
					InterfacesApiUser.find_or_create_by(interface_id: interface_id.to_i, api_user_id: api_user_id)
				end
			end
		end
	end
end

# == Schema Information
#
# Table name: send_logs
#
#  id          :integer          not null, primary key
#  alarm_id    :integer
#  accept_user :string(255)
#  info        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SendLog < ActiveRecord::Base
	belongs_to :alarm

	def get_catcher
		Member.where(openid: accept_user).first.try(:name)
	end
end

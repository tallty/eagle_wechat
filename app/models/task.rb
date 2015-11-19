# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  identifier  :string(255)
#  name        :string(255)
#  rate        :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  customer_id :integer
#

class Task < ActiveRecord::Base
	belongs_to :customer
  has_many :sms_logs, dependent: :destroy
	after_initialize :task_identifier

  # 找到task对应的最新的task_log
  def find_task_log
    TaskLog.where(task_identifier: identifier).last
  end

	private
    def task_identifier
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      self.identifier ||= chars.sample(8).join
    end
end

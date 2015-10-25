# == Schema Information
#
# Table name: task_logs
#
#  id              :integer          not null, primary key
#  start_time      :datetime
#  end_time        :datetime
#  task_identifier :string(255)
#  exception       :string(255)
#  file_name       :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class TaskLog < ActiveRecord::Base
end

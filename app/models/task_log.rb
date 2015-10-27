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
#  task_name       :string(255)
#  identifier      :string(255)
#

class TaskLog < ActiveRecord::Base

<<<<<<< HEAD
<<<<<<< HEAD
  def self.process
    list = $redis.hvals("task_log_cache").map { |e| MultiJson.load e }
    list.each do |item|
      # 入库
      log = TaskLog.find_or_create_by identifier: item["identifier"], start_time: Time.at(item["start_time"])
      log.end_time = Time.at(item["end_time"])
      # log.
    end
  end
=======
>>>>>>> 459b371d9e5f57bc0d14ecf23b0877b00a7526b0
=======
>>>>>>> 7656fa29784d0963351dd9c8eac4cf83d006697a
end

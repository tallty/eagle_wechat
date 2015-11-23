# == Schema Information
#
# Table name: machines
#
#  id               :integer          not null, primary key
#  identifier       :string(255)
#  name             :string(255)
#  explain          :string(255)
#  operating_status :integer          default(0)
#  customer_id      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  cpu_type         :string(255)
#

class Machine < ActiveRecord::Base
  belongs_to :customer
  has_one :machine_detail
  has_many :disk_infos
  enum operating_status: { stoped: 0, running: 1 }

  after_initialize :generate_identifier

  #计算机器的cpu占比
  def cpu_percent
    cache = MachineInfo.get_info("cpu", identifier)
    if cache.nil?
      nil
    else
      return "#{eval(cache)["cpu_used"].to_i}%"
    end
  end

  #计算指定机器的内存占用比
  def memory_percent
    cache = MachineInfo.get_info("memory", identifier)
    if cache.nil?
      nil
    else
      memory_data = eval(cache) 
      memory_free = memory_data["memory_free_bytes"].to_f
      memory_total = memory_data["memory_total_bytes"].to_f
      memory_used = (((memory_total - memory_free) / memory_total) * 100).round(1)
      "#{memory_used}%"
    end
  end

  #已用内存
  def memory_used
    cache = MachineInfo.get_info("memory", identifier)
    if cache.nil?
      nil
    else
      memory_data = eval(cache) 
      return memory_data["memory_total_bytes"].to_i - memory_data["memory_free_bytes"].to_i
    end
  end

  # 判断服务器是否正常
  def nomal?
    alarm_info = Alarm.where(identifier: identifier).last

    if alarm_info.nil?
      true
    else
      if $redis.lindex("#{identifier}_cpu", -(alarm_info.rindex + 1)).present?
        true
      else
        false
      end
    end
  end

  private

  def generate_identifier
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    self.identifier ||= chars.sample(16).join
  end  

end

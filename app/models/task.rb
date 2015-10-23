class Task < ActiveRecord::Base
	belongs_to :customer
	after_initialize :task_identifier
	private

  def task_identifier
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    self.identifier ||= chars.sample(8).join
  end  
end

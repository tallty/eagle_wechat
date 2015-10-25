class InterfaceReport < ActiveRecord::Base

  def self.process
    now_date = Time.now.to_date - 1.day
    
  end
end

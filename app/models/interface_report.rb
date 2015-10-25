class InterfaceReport < ActiveRecord::Base

  def self.process
    now_date = Time.now.to_date - 1.day
    list = TotalInterface.today(now_date)
    list.each do |item|
      p item
    end
  end
end

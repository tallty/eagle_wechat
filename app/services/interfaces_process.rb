class InterfacesProcess

  def self.push(raw_post)
    Rails.logger.warn ">>>>>>>>>>>>>>>>>>接收接口计数,执行任务<<<<<<<<<<<<<<<<<<<<"
    TotalInterface.new.analyz_fetch_data raw_post
  end
end

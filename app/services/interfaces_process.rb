class InterfacesProcess

  def self.push(raw_post)
    logger.warn ">>>>>>>>>>>>>>>>>>接收接口计数,执行任务<<<<<<<<<<<<<<<<<<<<"
    TotalInterface.new.analyz_fetch_data raw_post
  end
end

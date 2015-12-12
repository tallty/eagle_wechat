class InterfacesProcess

  def self.push(raw_post)
    params_hash = MultiJson.load raw_post
    $redis.set "interface_fetch_cache", raw_post
    identifier = params_hash["identifier"]

    data = MultiJson.load params_hash["data"]

    total_interface = nil
    today = Time.now.strftime('%Y-%m-%d')
    data.each do |item|
      next if item['appid'].eql?('ZfQg2xyW04X3umRPsi9H')
      item_name = Interface.get_interface_name item['interface_name']
      api_user = ApiUser.where(appid: item["appid"]).first
      if item_name.blank?
        item_name = item["name"]
      end
      datetime = Time.parse(item["datetime"])# + 8.hour
      total_interface = TotalInterface.where(datetime: datetime, identifier: identifier, name: item_name, api_user: api_user).first
      if total_interface.blank?
        total_interface = TotalInterface.new
        total_interface.datetime   = datetime
        total_interface.identifier = identifier
        total_interface.name       = item_name
        total_interface.api_user   = api_user
      end
      if total_interface.try(:count).blank? or total_interface.count < item['interface_count'].to_i
        total_interface.count = item["interface_count"].to_i
      end

      total_interface.save

      $redis.zadd "interface_top_#{item['interface_name']}_#{today}", total_interface.count, total_interface.to_json
    end

    # 计算接口调用总数
    TotalInterface.new.write_sum_to_cache

    total_interface = nil
  end
end

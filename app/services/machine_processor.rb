class MachineProcessor < BaseService

  # 解析接收到的服务器状态数据,如果数据有异常,报警
  def self.push(raw_post)
    item = MultiJson.load raw_post
    begin

    rescue => e
    end
  end

end

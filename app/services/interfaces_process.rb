class InterfacesProcess

  def self.push(raw_post)
    TotalInterface.new.analyz_fetch_data raw_post
  end
end

module BasePusher

  def get_client
    pusher_client = Pusher::Client.new(
      app_id: '194445',
      key: '22aafd365316e4b176ba',
      secret: '72af378d080cfa4da858',
      encrypted: true
    )
  end

end

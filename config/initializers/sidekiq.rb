Sidekiq.configure_server do |config|
  config.redis = {url: "redis://localhost:6379/1", namespace: 'highlander_sidekiq'}
  # config.redis = {url: "redis://:shtzr840329@localhost:6379/1", namespace: 'highlander_sidekiq'}
end

Sidekiq.configure_client do |config|
  config.redis = {url: "redis://localhost:6379/1", namespace: 'highlander_sidekiq'}
end

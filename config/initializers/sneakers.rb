Sneakers.configure({
    :workers => 2,
    :threads => 20,
    :share_threads => true,
    :log => 'log/sneakers.log',
    :daemonize => true
})
Sneakers.logger.level = Logger::INFO

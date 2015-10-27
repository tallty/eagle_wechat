# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# User.create!(id: 1, name: 'user', phone: '13800000000', email: 'eagle@eagle.com', password: 'eagle2015', password_confirmation: 'eagle2015')

Diymenu.delete_all
Diymenu.create(id: 1, name: '分析统计', is_show: true, sort: 0)
Diymenu.create(id: 2, name: '告警列表', is_show: true, sort: 1)
Diymenu.create(id: 3, name: '监控诊断', is_show: true, sort:2)
Diymenu.create(id: 4, parent_id: 1, name: '月报表', url: 'http://mcu.buoyantec.com/oauths?target_url=weather/statement', is_show: true, sort:0)
Diymenu.create(id: 5, parent_id: 1, name: '周报表', url: 'http://mcu.buoyantec.com/oauths?target_url=weather/statement', is_show: true, sort:1)
Diymenu.create(id: 6, parent_id: 1, name: '日报表', url: 'http://mcu.buoyantec.com/oauths?target_url=weather/statement', is_show: true, sort:2)
Diymenu.create(id: 7, parent_id: 2, name: '历史告警', url: 'http://mcu.buoyantec.com/oauths?target_url=weather/history', is_show: true, sort:0)
Diymenu.create(id: 8, parent_id: 2, name: '活跃告警', url: 'http://mcu.buoyantec.com/oauths?target_url=weather/active', is_show: true, sort:1)
Diymenu.create(id: 9, parent_id: 3, name: '调用接口', url: 'http://mcu.buoyantec.com/oauths?target_url=weather/port', is_show: true, sort:0)
Diymenu.create(id: 10, parent_id: 3, name: '气象数据', url: 'http://mcu.buoyantec.com/oauths?target_url=weather/meteorologic', is_show: true, sort:1)
Diymenu.create(id: 11, parent_id: 3, name: '服务器', url: 'http://mcu.buoyantec.com/oauths?target_url=machines', is_show: true, sort:2)

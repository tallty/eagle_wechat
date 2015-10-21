class TaskLogsController < ApplicationController
  protect_from_forgery :except => :index
  skip_before_filter :verify_authenticity_token,:only => [:base_hardware_info, :real_hardware_info]
  respond_to :json

  def fetch
    p params
    render :text => 'ok'
  end

end

# [{"typhoonid": "1525","enname": "CHAMPI","cnname": "","datainfo": "","reportcenter": "BCSH","tyear": "2015","lastreporttime": "2015/10/21 14:00:00"},{"typhoonid": "1524","enname": "KOPPU","cnname": "巨爵","datainfo": "","reportcenter": "BCSH","tyear": "2015","lastreporttime": "2015/10/20 23:00:00"},{"typhoonid": "1523","enname": "CHOI-WAN","cnname": "彩云","datainfo": "","reportcenter": "BCSH","tyear": "2015","lastreporttime": "2015/10/08 08:00:00"},{"typhoonid":"1522","enname":"MUJIGAE","cnname":"彩虹","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/10/05 11:00:00"},{"typhoonid":"1521","enname":"DUJUAN","cnname":"杜鹃","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/09/29 11:00:00"},{"typhoonid":"1520","enname":"KROVANH","cnname":"科罗旺","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/09/20 20:00:00"},{"typhoonid":"1519","enname":"VAMCO","cnname":"环高","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/09/15 02:00:00"},{"typhoonid":"1509","enname":"chanhom","cnname":"灿鸿","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/09/14 02:00:00"},{"typhoonid":"1517","enname":"KILO","cnname":"","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/09/11 08:00:00"},{"typhoonid":"1518","enname":"ETAU","cnname":"艾涛","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/09/09 14:00:00"},{"typhoonid":"1515","enname":"GONI","cnname":"","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/08/27 08:00:00"},{"typhoonid":"1516","enname":"ATSANI","cnname":"","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/08/25 20:00:00"},{"typhoonid":"1514","enname":"MOLAVE","cnname":"莫拉菲","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/08/13 20:00:00"},{"typhoonid":"1513","enname":"SOUDELOR","cnname":"苏迪罗","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/08/10 14:00:00"},{"typhoonid":"1512","enname":"HALOLA","cnname":"","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/07/26 20:00:00"},{"typhoonid":"1511","enname":"NANGKA","cnname":"浪卡","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/07/18 02:00:00"},{"typhoonid":"1510","enname":"LINFA","cnname":"莲花","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/07/10 02:00:00"},{"typhoonid":"1508","enname":"KUJIRA","cnname":"鲸鱼","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/06/25 02:00:00"},{"typhoonid":"1507","enname":"DOLPHIN","cnname":"白海豚","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/05/20 14:00:00"},{"typhoonid":"1506","enname":"NOUL","cnname":"红霞","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/05/12 14:00:00"},{"typhoonid":"1505","enname":"HAISHEN","cnname":"海神","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/04/06 14:00:00"},{"typhoonid":"1504","enname":"MAYSAK","cnname":"美莎克","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/04/06 08:00:00"},{"typhoonid":"1503","enname":"BAVI","cnname":"巴威","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/03/17 20:00:00"},{"typhoonid":"1502","enname":"HIGOS","cnname":"海高斯","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/02/11 20:00:00"},{"typhoonid":"1501","enname":"MEKKHALA","cnname":"米克拉","datainfo":"","reportcenter":"BCSH","tyear":"2015","lastreporttime":"2015/01/18 23:00:00"},{"typhoonid":"1423","enname":"JANGMI","cnname":"","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/12/31 20:00:00"},{"typhoonid":"1422","enname":"HAGUPIT","cnname":"黑格比","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/12/12 02:00:00"},{"typhoonid":"1421","enname":"SINLAKU","cnname":"森拉克","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/11/30 11:00:00"},{"typhoonid":"1420","enname":"NURI","cnname":"鹦鹉","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/11/06 14:00:00"},{"typhoonid":"1419","enname":"VONGFONG","cnname":"黄蜂","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/10/13 20:00:00"},{"typhoonid":"1418","enname":"PHANFONE","cnname":"巴蓬","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/10/06 14:00:00"},{"typhoonid":"1417","enname":"KAMMURI","cnname":"北冕","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/09/29 20:00:00"},{"typhoonid":"1416","enname":"FUNG-WONG","cnname":"凤凰","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/09/24 10:00:00"},{"typhoonid":"1415","enname":"KALMAEGI","cnname":"海鸥","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/09/17 14:00:00"},{"typhoonid":"1414","enname":"FENGSHEN","cnname":"风神","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/09/10 14:00:00"},{"typhoonid":"1413","enname":"GENEVIEVE","cnname":"","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/08/12 02:00:00"},{"typhoonid":"1411","enname":"HALONG","cnname":"夏浪","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/08/11 14:00:00"},{"typhoonid":"1412","enname":"NAKRI","cnname":"娜基莉","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/08/04 05:00:00"},{"typhoonid":"1410","enname":"MATMO","cnname":"麦德姆","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/07/25 20:00:00"},{"typhoonid":"1409","enname":"RAMMASUN","cnname":"","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/07/20 05:00:00"},{"typhoonid":"1408","enname":"NEOGURI","cnname":"","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/07/11 08:00:00"},{"typhoonid":"1407","enname":"HAGIBIS","cnname":"海贝思","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/06/18 02:00:00"},{"typhoonid":"1406","enname":"MITAG","cnname":"米娜","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/06/12 08:00:00"},{"typhoonid":"1405","enname":"TAPAH","cnname":"塔巴","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/05/01 08:00:00"},{"typhoonid":"1404","enname":"PEIPAH","cnname":"琵琶","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/04/10 02:00:00"},{"typhoonid":"1403","enname":"FAXAI","cnname":"法茜","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/03/06 02:00:00"},{"typhoonid":"1402","enname":"KAJIKI","cnname":"剑鱼","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/02/01 17:00:00"},{"typhoonid":"1401","enname":"LINGLING","cnname":"玲玲","datainfo":"","reportcenter":"BCSH","tyear":"2014","lastreporttime":"2014/01/20 08:00:00"}]
# [
#   {
#     "typhoonid": "1525",
#     "enname": "CHAMPI",
#     "cnname": "",
#     "datainfo": "",
#     "reportcenter": "BCSH",
#     "tyear": "2015",
#     "lastreporttime": "2015/10/21 14:00:00"
#   },
#   {
#     "typhoonid": "1524",
#     "enname": "KOPPU",
#     "cnname": "巨爵",
#     "datainfo": "",
#     "reportcenter": "BCSH",
#     "tyear": "2015",
#     "lastreporttime": "2015/10/20 23:00:00"
#   },
#   {
#     "typhoonid": "1523",
#     "enname": "CHOI-WAN",
#     "cnname": "彩云",
#     "datainfo": "",
#     "reportcenter": "BCSH",
#     "tyear": "2015",
#     "lastreporttime": "2015/10/08 08:00:00"
#   }
# ]

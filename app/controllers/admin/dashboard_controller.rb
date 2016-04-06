module Admin
	class DashboardController < ApplicationController
    include ActionView::Helpers::NumberHelper
    skip_before_filter :authenticate_user!
    layout 'dashboard'
    respond_to :html, :js

		def index
      @real_time_weather = Weather.new.get_real_time_weather
      @district_weathers = Weather.new.get_district_weather
      @sum_interface =  number_with_delimiter(TotalInterface.get_sum_from_cache)
      @upload_count = number_with_delimiter(UploadInfo.new.get_total)
      @machines = Customer.first.machines.where(operating_status: 1)

      names = ['生活指数', '上海当天预报', '全市预警', '上海区县主站实况', '上海自动站历史']
      @interface_counter = Hash.new(0)
      names.each do |name|
        result = TotalInterface.new.all_count_by_datetime(Customer.first, name)
        @interface_counter[name] = result
      end

      interface_arr = $redis.hvals("interface_sort_v7XGbzhd_#{DateTime.now.to_date}")
      interface_arr = interface_arr.map { |e| MultiJson.load(e) }
      interface_arr.each { |e| e.delete('times') }
      interface_arr.sort! {|item, item2| item2['all_count'] <=> item['all_count']}
      @result = Array.new(interface_arr[0..5])
      @result << {:name => '其它', :all_count => interface_arr[5..-1].inject(0) {|sum, value| sum + value['all_count']}}
      @api_users_sort = ApiUser.new.get_api_user_sort(Customer.first, DateTime.now.strftime("%F"))
      @task_logs = TaskLog.new.get_task_logs(Customer.first.id)
      @task_names = []
      @task_logs.each {|e| @task_names << e[0]}
      @task_names = @task_names.uniq
		end


	end
end

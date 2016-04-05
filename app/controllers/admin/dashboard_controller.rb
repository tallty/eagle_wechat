module Admin
	class DashboardController < BaseController
    include ActionView::Helpers::NumberHelper

    layout 'dashboard'
    respond_to :html, :js

		def index
      @real_time_weather = Weather.new.get_real_time_weather
      @district_weathers = Weather.new.get_district_weather
      @sum_interface =  number_with_delimiter(TotalInterface.get_sum_from_cache)
      @machines = Customer.first.machines.where(operating_status: 1)

      names = ['生活指数', '上海当天预报', '全市预警', '上海区县主站实况', '上海自动站历史']
      @interface_counter = Hash.new(0)
      names.each do |name|
        result = TotalInterface.new.all_count_by_datetime(Customer.first, name)
        @interface_counter[name] = result
      end

		end


	end
end

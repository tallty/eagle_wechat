module Admin
	class DashboardController < BaseController
    layout 'dashboard'
    respond_to :html, :js

		def index
      @real_time_weather = Weather.new.get_real_time_weather
      @district_weathers = Weather.new.get_district_weather
      @sum_interface = TotalInterface.get_sum_from_cache
      @machines = Customer.first.machines.where(operating_status: 1)
		end


	end
end

class MachineDetailsController < ApplicationController
	def index
		@customer =  Customer.first
		@machines = @customer.machines
	end

	def show
		@machine = Machine.find(params[:id])
		@cpus = MachineInfo.get_list("cpu", @machine.identifier)
		@memorys = MachineInfo.get_list("memory", @machine.identifier)
		@net_works = MachineInfo.get_list("net_work", @machine.identifier)
	end
end

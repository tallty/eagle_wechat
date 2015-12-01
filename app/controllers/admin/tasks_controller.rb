module Admin
	class TasksController < BaseController
		before_action :set_task, only: [:show, :edit, :update, :destroy]
		before_action :set_customer, only: [:index, :new, :create, :edit]
		respond_to :html, :js

		def index
		end

		def show
		end

		def new
			@task = @customer.tasks.new
			respond_with @task
		end

		def edit
			respond_with @task
		end

		def create
			@task = @customer.tasks.new(task_params)

			if @task.save
				flash[:notice] = "任务创建成功"
				respond_with @task
			else
				flash[:error] = "任务创建失败"
				render :new
			end
		end

		def update
			if @task.update(task_params)
				flash[:notice] = "更新成功"
			else
				flash[:error] = "更新失败"
			end
		end

		def destroy
			@task.destroy
			redirect_to admin_customer_tasks_path
		end

		private
			# Use callbacks to share common setup or constraints between actions.
			def set_task
				@task = Task.find(params[:id])
			end

			def set_customer
				@customer = Customer.find(params[:customer_id])
			end
			# Never trust parameters from the scary internet, only allow the white list through.
			def task_params
				params.require(:task).permit(:identifier, :name, :rate, :alarm_threshold)
			end
	end
end

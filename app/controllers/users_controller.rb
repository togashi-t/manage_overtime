class UsersController < ApplicationController
  def index
    @users = User.all.order(:group)

    gon.group_monthly_chart_data = Overtime.group_monthly_chart_data
  end

  def show
    @user = User.find(params[:id])

    gon.monthly_chart_data = Overtime.monthly_chart_data(params[:id])

    @overtimes = Overtime.this_month_overtimes(params[:id])
  end
end

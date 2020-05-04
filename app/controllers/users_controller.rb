class UsersController < ApplicationController
  def index
    @users = User.all.order(:group)
    gon.group_monthly_chart_data = Overtime.group_monthly_chart_data
  end

  def show
    gon.recorded_dates = User.find(params[:id]).recorded_dates
    gon.overtimes_devided_into_hour_and_minute = User.find(params[:id]).overtimes_devided_into_hour_and_minute
    gon.monthly_chart_data = User.find(params[:id]).monthly_chart_data
    @overtimes = User.find(params[:id]).this_month_overtimes
  end
end

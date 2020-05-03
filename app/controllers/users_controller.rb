class UsersController < ApplicationController
  def index
    @users = User.all.order(:group)
    gon.group_monthly_chart_data = Overtime.group_monthly_chart_data
  end

  def show
    # User.find(params[:id])は後にcurrent_userに修正予定
    gon.recorded_dates = User.find(params[:id]).overtimes.map(&:date)
    # edit-calendar用のデータ渡しを追加予定
    # gon~ = ~
    gon.monthly_chart_data = Overtime.monthly_chart_data(params[:id])
    @overtimes = Overtime.this_month_overtimes(params[:id])
  end
end

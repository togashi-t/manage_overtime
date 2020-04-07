class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    gon.monthly_chart_data = Overtime.monthly_chart_data(params[:id])
  end
end

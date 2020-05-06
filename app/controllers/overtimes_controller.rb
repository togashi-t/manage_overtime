class OvertimesController < ApplicationController
  before_action :authenticate_user!


  def create
    @overtime = current_user.overtimes.build(overtime_params)
    date = @overtime.date&.strftime("%Y年%-m月%-d日")
    if @overtime.save!
      flash[:info] = "#{date}の記録を追加しました"
    else
      flash[:danger] = "エラーが発生しました"
    end
    redirect_to user_path(current_user)
  end

  private

    def overtime_params
      params.require(:overtime).permit(:date, :work_start_time, :work_end_time, :work_time)
    end
end

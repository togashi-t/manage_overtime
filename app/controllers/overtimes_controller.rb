class OvertimesController < ApplicationController
  before_action :authenticate_user!


  def create
    @overtime = current_user.overtimes.build(overtime_params)
    date = @overtime.date&.strftime("%Y年%-m月%-d日")
    respond_to do |format|
      if @overtime.save!
        flash[:info] = "#{date}の記録を追加しました"
        format.html { redirect_to user_path(current_user) }
        format.js { render js: "window.location = '#{user_path(current_user)}'" }
      else
        @overtime.errors.each do |name, msg|
          flash.now[name] = msg
        end
        format.html { redirect_to user_path(current_user) }
        format.js { render partial: "shared/flash_messages", status: :unprocessable_entity }
      end
    end
  end

  def update
    @overtime = current_user.overtimes.find_by(date: params[:overtime][:date])
    date = @overtime.date&.strftime("%Y年%-m月%-d日")
    if params[:destroy].nil?
      if @overtime.update!(overtime_params)
        flash[:info] = "#{date}の記録を修正しました"
      else
        flash[:danger] = "エラーが発生しました"
      end
    else
      if @overtime.destroy!
        flash[:info] = "#{date}の記録を削除しました"
      else
        flash[:danger] = "エラーが発生しました"
      end
    end
    redirect_to user_path(current_user)
  end

  private

    def overtime_params
      params.require(:overtime).permit(:date, :work_start_time, :work_end_time, :work_time)
    end
end

class OvertimesController < ApplicationController
  before_action :authenticate_user!

  def create
    @overtime = current_user.overtimes.build(overtime_params)
    date = @overtime.date&.strftime("%Y年%-m月%-d日")
    if @overtime.save
      flash[:info] = "#{date}の記録を追加しました"
      render js: "window.location = '#{user_path(current_user)}'"
    else
      @overtime.errors.each do |name, msg|
        jp_name = I18n.t("activerecord.attributes.overtime")[name]
        flash.now[jp_name] = msg
      end
      render partial: "shared/flash_messages", status: :unprocessable_entity
    end
  end

  def update
    @overtime = current_user.overtimes.find_by(date: params[:overtime][:date])
    if @overtime.nil?
      jp_name = I18n.t("activerecord.attributes.overtime")[:date]
      flash.now[jp_name] = "を入力して下さい"
      render partial: "shared/flash_messages", status: :unprocessable_entity
      return
    end
    date = @overtime.date&.strftime("%Y年%-m月%-d日")
    if params[:destroy].nil?
      if @overtime.update(overtime_params)
        flash[:info] = "#{date}の記録を修正しました"
        render js: "window.location = '#{user_path(current_user)}'"
      else
        @overtime.errors.each do |name, msg|
          jp_name = I18n.t("activerecord.attributes.overtime")[name]
          flash.now[jp_name] = msg
        end
        render partial: "shared/flash_messages", status: :unprocessable_entity
      end
    else
      @overtime.destroy!
      flash[:info] = "#{date}の記録を削除しました"
      render js: "window.location = '#{user_path(current_user)}'"
    end
  end

  private

    def overtime_params
      params.require(:overtime).permit(:date, :work_start_time, :work_end_time, :work_time)
    end
end

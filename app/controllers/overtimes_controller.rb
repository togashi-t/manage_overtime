class OvertimesController < ApplicationController
  def index
  end

  def create
    @overtime = current_user.overtimes.build(overtime_params)
    @overtime.save!
  end


  private
    def overtime_params
      params.require(:overtime).permit(:date, :work_start_time, :work_end_time, :work_time )
    end
end

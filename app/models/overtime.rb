class Overtime < ApplicationRecord
  belongs_to :user
  attr_accessor :work_time
  before_validation :convert_work_time_to_work_time_minute

  def self.monthly_chart_data(userid)
    monthly_minute_data = Overtime.where(user_id: userid).group("DATE_FORMAT(date,'%Y年%m月')").sum(:work_time_minute)
    monthly_hour_data = {}
    monthly_minute_data.each do |key, value|
      monthly_hour_data[key] = value / 60
    end
    monthly_hour_data
  end

  # def self.monthly_chart_data(user)
  #   monthly_minute_data = user.overtimes.group("DATE_FORMAT(date,'%Y年%m月')").sum(:work_time_minute)
  #   monthly_hour_data = {}
  #   monthly_minute_data.each do |key, value|
  #     monthly_hour_data[key] = value / 60
  #   end
  #   monthly_hour_data
  # end

  private

    def convert_work_time_to_work_time_minute
      self.work_time_minute = Tod::TimeOfDay.parse(self.work_time).to_i / 60
    end
end

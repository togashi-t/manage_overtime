class Overtime < ApplicationRecord
  belongs_to :user
  attr_accessor :work_time
  before_validation :convert_work_time_to_work_time_minute


  # show-table用
  def self.this_month_overtimes(userid)
    this_month = Time.zone.now.all_month
    Overtime.where(user_id: userid).where(date: this_month)
  end

  # show-chart用
  def self.monthly_chart_data(userid)
    # {[2019, 4]=>○○○○, [2019, 5]=>○○○○, …} を生成
    year_and_month_minute_data = Overtime.where(user_id: userid).group("extract(year from date)").group("extract(month from date)").sum(:work_time_minute)
    monthly_hour_data = {}
    year_and_month_minute_data.each do |key, value|
      monthly_hour_data["#{key[0].floor}年#{key[1].floor}月"] = value / 60
    end
    monthly_hour_data
  end

  private

    def convert_work_time_to_work_time_minute
      self.work_time_minute = Tod::TimeOfDay.parse(self.work_time).to_i / 60
    end
end

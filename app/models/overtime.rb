class Overtime < ApplicationRecord
  belongs_to :user
  attr_accessor :work_time
  before_validation :convert_work_time_to_work_time_minute



  # index-table用
  # {user_id: XX（分）, ...}
  def self.this_month_minute_data
    this_month = Time.zone.now.all_month
    this_month_minute_data = Overtime.where(date: this_month).group(:user_id).sum(:work_time_minute)
  end

  def self.estimate_value_at_the_end_of_month(value)
    today = Date.today
    day_of_today = today.day
    last_day_of_month = today.end_of_month.day
    progress_rate = day_of_today.to_f / last_day_of_month
    value / progress_rate
  end

  # {user_id: {today: XX（時間）, end_of_month: XX（時間）}, ...}
  def self.this_month_hour_data
    this_month_hour_data = {}
    Overtime.this_month_minute_data.each do |key, value|
      hour_until_today = value.to_f / 60
      this_month_hour_data[key] = { today: hour_until_today.floor(1),
                                    end_of_month: Overtime.estimate_value_at_the_end_of_month(hour_until_today).floor(1) }
    end
    this_month_hour_data
  end


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

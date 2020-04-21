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
    # {["2019年4月"=>○○○○, "2019年4月"=>○○○○, …} に成形
    monthly_hour_data = {}
    year_and_month_minute_data.each do |key, value|
      monthly_hour_data["#{key[0].floor}年#{key[1].floor}月"] = (value.to_f / 60).floor(1)
    end
    monthly_hour_data
  end


  # index-chart用
  def self.group_monthly_hour_data
    # {["A", "2019年4月"]=>1828, ["A", "2019年5月"]=>6418, ...} を生成
    group_monthly_minute_data = Overtime.joins(:user).select("overtimes*, users*").group("users.group").group("DATE_FORMAT(date,'%Y年%c月')").sum(:work_time_minute)
    hash = {}
    group_monthly_minute_data.each do |key, value|
      hash[key] = (value.to_f / 60).floor(1)
    end
    hash
  end

  def self.group_monthly_chart_data
    # {"A"=> {"2019年4月"=>30.4, "2019年5月"=>106.9, ...} に成形
    hash = Hash.new { |h,k| h[k] = {} }
    Overtime.group_monthly_hour_data.each do |key, value|
      hash[key[0]][key[1]] = value
    end
    hash
  end


  private

    def convert_work_time_to_work_time_minute
      self.work_time_minute = Tod::TimeOfDay.parse(self.work_time).to_i / 60
    end
end

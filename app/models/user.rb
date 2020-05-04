class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :overtimes, dependent: :destroy

  # index
  # index-table用
  def this_month_minute
    this_month = Time.zone.now.all_month
    self.overtimes.where(date: this_month).sum(:work_time_minute)
  end

  # show
  # edit-calendar用
  def recorded_dates
    self.overtimes.map(&:date)
  end

  # show-chart用
  def monthly_chart_data
    # {[2019, 4]=>○○○○, [2019, 5]=>○○○○, …} を生成
    year_and_month_minute_data = self.overtimes.group("DATE_FORMAT(date,'%Y年%c月')").sum(:work_time_minute)
    # {["2019年4月"=>○○○○, "2019年4月"=>○○○○, …} に成形
    monthly_hour_data = {}
    year_and_month_minute_data.each do |key, value|
      monthly_hour_data[key] = (value.to_f / 60).floor(1)
    end
    monthly_hour_data
  end

  # show-table用
  def this_month_overtimes
    this_month = Time.zone.now.all_month
    self.overtimes.where(date: this_month)
  end





  # show-table用
  def self.this_month_overtimes(userid)
    this_month = Time.zone.now.all_month
    Overtime.where(user_id: userid).where(date: this_month)
  end

end

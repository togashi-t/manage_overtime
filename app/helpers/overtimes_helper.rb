module OvertimesHelper
  def extract_date(date)
    date.strftime("%e")
  end

  def extract_day(date)
    wd = ["日", "月", "火", "水", "木", "金", "土"]
    date.strftime((wd[date.wday]).to_s)
  end

  def extract_time(date_time)
    date_time.strftime("%H:%M")
  end

  def convert_to_hour_and_minute(in_minutes)
    hour = in_minutes / 60
    minute = in_minutes % 60
    "#{"%02d" % hour}:#{"%02d" % minute}"
  end

  def convert_to_hour(in_minutes)
    hour = (in_minutes.to_f / 60).floor(1)
  end

  def estimate_value_at_the_end_of_month(value)
    today = Date.today
    day_of_today = today.day
    last_day_of_month = today.end_of_month.day
    progress_rate = day_of_today.to_f / last_day_of_month
    value / progress_rate
  end


end

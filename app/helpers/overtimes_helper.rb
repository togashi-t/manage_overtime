module OvertimesHelper
  def extract_date(date)
    date.strftime("%e")
  end

  def extract_day(date)
    wd = ["日", "月", "火", "水", "木", "金", "土"]
    date.strftime("#{wd[date.wday]}")
  end

  def extract_time(date_time)
    date_time.strftime("%H:%M")
  end

  def convert_to_hour_and_minute(in_minutes)
    hour = in_minutes / 60
    minute = in_minutes % 60
    "#{sprintf("%02d", hour)}:#{sprintf("%02d", minute)}"
  end
end

# テストユーザー情報
NAME = "test_user".freeze
GROUP = "A".freeze
EMAIL = "test@example.com".freeze
PASSWORD = "password".freeze

# overtime
# データの入力期間
START_DATE = Date.today - 12.months
END_DATE = Date.today

# 記録する時刻の範囲
WORK_START_TIME = Tod::TimeOfDay.parse("17:15")
# => #<Tod::TimeOfDay:0x00007f8bc84accb0 @hour=17, @minute=15, @second=0, @second_of_day=62100>
MIN_WORK_END_TIME = Tod::TimeOfDay.parse("17:16")
MIN_WORK_END_TIME_SCOND = MIN_WORK_END_TIME.second_of_day
MAX_WORK_END_TIME = Tod::TimeOfDay.parse("24:00")
MAX_WORK_END_TIME_SECOND = MAX_WORK_END_TIME.second_of_day

# 入力確率 1/(RECORD_CONSTANT) の確率でデータを記録
RECORD_CONSTANT = 3

user = User.find_or_create_by!(email: EMAIL) do |user|
  user.name = NAME
  user.group = GROUP
  user.password = PASSWORD
  puts "テストユーザーの初期データインポートに成功しました。"
end

user.overtimes.destroy_all

overtimes = []
(START_DATE..END_DATE).each do |date|
  next unless rand(RECORD_CONSTANT).zero?

  WORK_END_TIME = Tod::TimeOfDay.new(0) + rand(MIN_WORK_END_TIME_SCOND..MAX_WORK_END_TIME_SECOND)
  overtimes << {
    user_id: user.id,
    date: date,
    work_start_time: WORK_START_TIME.to_s,
    work_end_time: WORK_END_TIME.to_s,
    work_time: (WORK_END_TIME - WORK_START_TIME).to_s,
  }
end
Overtime.create!(overtimes)
puts "残業日時の初期データ投入に成功しました。"

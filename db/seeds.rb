# user
GROUPS = ["A", "B", "C"].freeze
PASSWORD = "password".freeze

users = []
3.times {
  GROUPS.each do |group|
    users << {
      name: Gimei.unique.name.kanji,
      group: group,
      email: Faker::Internet.email,
      password: PASSWORD,
    }
  end
}
User.create!(users)
puts "テストユーザーの初期データを投入しました"

# overtime
# データの入力期間
START_DATE = Date.today - 12.months
END_DATE = Date.today

# 記録する時刻の範囲
WORK_START_TIME = Tod::TimeOfDay.parse("17:15")
# => #<Tod::TimeOfDay:0x00007f8bc84accb0 @hour=17, @minute=15, @second=0, @second_of_day=62100>
MIN_WORK_END_TIME = Tod::TimeOfDay.parse("17:16")
MIN_WORK_END_TIME_MINUTE = MIN_WORK_END_TIME.second_of_day / 60
MAX_WORK_END_TIME = Tod::TimeOfDay.parse("24:00")
MAX_WORK_END_TIME_MINUTE = MAX_WORK_END_TIME.second_of_day / 60

# 入力確率 1/rand(RECORD_CONSTANT_RANGE) の確率でデータを記録
RECORD_CONSTANT_RANGE = (3..6).freeze

overtimes = []
users = User.order("id")
# 全ユーザーの内、最後のユーザーを除くユーザー
users.slice(0, users.length - 1).each do |user|
  record_constant = rand(RECORD_CONSTANT_RANGE)
  (START_DATE..END_DATE).each do |date|
    next unless rand(record_constant).zero?

    work_end_time = Tod::TimeOfDay.new(0) + rand(MIN_WORK_END_TIME_MINUTE..MAX_WORK_END_TIME_MINUTE) * 60
    overtimes << {
      user_id: user.id,
      date: date,
      work_start_time: WORK_START_TIME.to_s,
      work_end_time: work_end_time.to_s,
      work_time: (work_end_time - WORK_START_TIME).to_s,
    }
  end
end

# 最後のユーザー
user = users.last
record_constant = rand(RECORD_CONSTANT_RANGE)
(START_DATE..END_DATE).each do |date|
  next if date.month.odd?

  work_end_time = Tod::TimeOfDay.new(0) + rand(MIN_WORK_END_TIME_MINUTE..MAX_WORK_END_TIME_MINUTE) * 60
    overtimes << {
      user_id: user.id,
      date: date,
      work_start_time: WORK_START_TIME.to_s,
      work_end_time: work_end_time.to_s,
      work_time: (work_end_time - WORK_START_TIME).to_s,
    }
end

Overtime.create!(overtimes)
puts "残業日時の初期データを投入しました。"

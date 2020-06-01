FactoryBot.define do
  WORK_START_TIME = Tod::TimeOfDay.parse("17:15")
  MIN_WORK_END_TIME = Tod::TimeOfDay.parse("17:16")
  MIN_WORK_END_TIME_MINUTE = MIN_WORK_END_TIME.second_of_day / 60
  MAX_WORK_END_TIME = Tod::TimeOfDay.parse("24:00")
  MAX_WORK_END_TIME_MINUTE = MAX_WORK_END_TIME.second_of_day / 60
  work_end_time = Tod::TimeOfDay.new(0) + rand(MIN_WORK_END_TIME_MINUTE..MAX_WORK_END_TIME_MINUTE) * 60

  factory :overtime do
    date { Faker::Time.between_dates(from: Date.today.beginning_of_month, to: Date.today.end_of_month) }
    work_start_time { WORK_START_TIME.to_s }
    work_end_time { work_end_time.to_s }
    work_time { (work_end_time - WORK_START_TIME).to_s }
    user
  end
end

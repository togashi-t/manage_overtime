class Overtime < ApplicationRecord
  belongs_to :user
  attr_accessor :work_time
  before_validation :convert_work_time_to_work_time_minutes

  private
    def convert_work_time_to_work_time_minutes
      self.work_time_minutes = (Tod::TimeOfDay.parse(self.work_time).to_i / 60)
    end
end

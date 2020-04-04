class AddWorkTimeMinutesToOvertimes < ActiveRecord::Migration[5.2]
  def change
    add_column :overtimes, :work_time_minutes, :integer
  end
end

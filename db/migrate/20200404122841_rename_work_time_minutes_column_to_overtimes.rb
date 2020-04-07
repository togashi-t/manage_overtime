class RenameWorkTimeMinutesColumnToOvertimes < ActiveRecord::Migration[5.2]
  def change
    rename_column :overtimes, :work_time_minutes, :work_time_minute
  end
end

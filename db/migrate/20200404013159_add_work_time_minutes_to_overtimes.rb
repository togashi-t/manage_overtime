class AddWorkTimeMinutesToOvertimes < ActiveRecord::Migration[5.2]
  def up
    add_column :overtimes, :work_time_minutes, :integer, null: false
  end

  def down
    remove_column :overtimes, :work_time_minutes, :integer, null: false
  end
end

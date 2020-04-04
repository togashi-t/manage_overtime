class RemoveWorkTimeFromOvertimes < ActiveRecord::Migration[5.2]
  def up
    remove_column :overtimes, :work_time, :time, null: false
  end

  def down
    add_column :overtimes, :work_time, :time, null: false
  end
end

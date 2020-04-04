class RemoveWorkTimeFromOvertimes < ActiveRecord::Migration[5.2]
  def change
    remove_column :overtimes, :work_time, :time
  end
end

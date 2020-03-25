class CreateOvertimes < ActiveRecord::Migration[5.2]
  def change
    create_table :overtimes do |t|
      t.date :date
      t.time :work_start_time
      t.time :work_end_time
      t.time :work_time

      t.timestamps
    end
  end
end

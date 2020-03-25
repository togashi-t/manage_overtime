class CreateOvertimes < ActiveRecord::Migration[5.2]
  def change
    create_table :overtimes do |t|
      t.date :date, null: false
      t.time :work_start_time, null: false
      t.time :work_end_time, null: false
      t.time :work_time, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :overtimes, [:user_id, :date], unique: true
  end
end

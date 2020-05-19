class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :detail, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

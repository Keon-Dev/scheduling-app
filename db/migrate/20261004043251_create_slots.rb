class CreateSlots < ActiveRecord::Migration[8.1]
  def change
    create_table :slots do |t|
      t.references :event, null: false, foreign_key: { on_delete: :cascade }
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false

      t.timestamps
    end
    add_index :slots, [ :event_id, :start_at ], unique: true
  end
end

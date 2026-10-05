class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events do |t|
      t.string :public_token, null: false
      t.string :title, null: false
      t.text :description
      t.integer :granularity, null: false, default: 0
      t.datetime :deadline
      t.integer :expected_participant_count
      t.references :owner_user, foreign_key: { to_table: :users, on_delete: :nullify }
      t.boolean :editable_by_anyone, null: false, default: true
      t.bigint :confirmed_slot_id
      t.datetime :confirmed_start_at
      t.datetime :confirmed_end_at

      t.timestamps
    end
    add_index :events, :public_token, unique: true
  end
end

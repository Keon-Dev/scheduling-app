class AddConfirmedSlotForeignKeyToEvents < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :events, :slots, column: :confirmed_slot_id, on_delete: :nullify
  end
end

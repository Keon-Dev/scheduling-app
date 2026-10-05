class CreateParticipants < ActiveRecord::Migration[8.1]
  def change
    create_table :participants do |t|
      t.references :event, null: false, foreign_key: { on_delete: :cascade }
      t.references :user, foreign_key: { on_delete: :nullify }
      t.string :name, null: false
      t.datetime :responded_at

      t.timestamps
    end

    add_index :participants, [ :event_id, :user_id ],
              unique: true, where: "user_id IS NOT NULL"
  end
end

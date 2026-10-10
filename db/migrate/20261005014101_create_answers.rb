class CreateAnswers < ActiveRecord::Migration[8.1]
  def change
    create_table :answers do |t|
      t.references :participant, null: false, index: false, foreign_key: { on_delete: :cascade }
      t.references :slot, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
    add_index :answers, [ :participant_id, :slot_id ], unique: true
  end
end

class CreateEventHiddenAxes < ActiveRecord::Migration[8.1]
  def change
    create_table :event_hidden_axes do |t|
      # on_delete: :cascadeは、親データが消えたときに子データも紐づいて消えること。対義語はon_delete: :nullify
      t.references :event, null: false, foreign_key: { on_delete: :cascade }
      t.integer :axis_kind, null: false
      t.date :hidden_date
      t.time :hidden_start_time
      t.time :hidden_end_time

      t.timestamps
    end

    add_index :event_hidden_axes, [ :event_id, :hidden_date ],
              unique: true, where: "axis_kind = 0",
              name: "index_event_hidden_axes_on_event_and_date"
    add_index :event_hidden_axes, [ :event_id, :hidden_start_time, :hidden_end_time ],
              unique: true, where: "axis_kind = 1",
              name: "index_event_hidden_axes_on_event_and_time_band"
  end
end

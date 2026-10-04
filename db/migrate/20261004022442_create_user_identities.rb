class CreateUserIdentities < ActiveRecord::Migration[8.1]
  def change
    create_table :user_identities do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.integer :provider, null: false
      t.string :uid, null: false
      t.string :workspace_id

      t.timestamps
    end
    add_index :user_identities, [ :provider, :uid, :workspace_id ], unique: true, nulls_not_distinct: true
    add_index :user_identities, [ :user_id, :provider, :workspace_id ], unique: true, nulls_not_distinct: true
  end
end

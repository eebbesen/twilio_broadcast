class CreateRecipientListMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :recipient_list_members do |t|
      t.references :recipient, null: false, foreign_key: true
      t.references :recipient_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end

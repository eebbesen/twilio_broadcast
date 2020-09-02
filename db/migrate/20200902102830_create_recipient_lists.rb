class CreateRecipientLists < ActiveRecord::Migration[6.0]
  def change
    create_table :recipient_lists do |t|
      t.string :name
      t.string :notes
      t.integer :user_id

      t.timestamps
    end
  end
end

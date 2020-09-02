class CreateMessageRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :message_recipients do |t|
      t.references :message, null: false, foreign_key: true
      t.references :recipient, null: false, foreign_key: true

      t.timestamps
    end
  end
end

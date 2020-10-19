class CreateIncomingSms < ActiveRecord::Migration[6.0]
  def change
    create_table :incoming_sms do |t|
      t.string :phone
      t.string :content
      t.string :request_type

      t.timestamps
    end
  end
end

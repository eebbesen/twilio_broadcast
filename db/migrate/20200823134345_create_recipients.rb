class CreateRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :recipients do |t|
      t.string :phone
      t.string :email
      t.string :name
      t.string :notes

      t.timestamps
    end
  end
end

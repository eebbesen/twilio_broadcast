class AddSidToMessageRecipients < ActiveRecord::Migration[6.0]
  def change
    add_column :message_recipients, :sid, :string
  end
end

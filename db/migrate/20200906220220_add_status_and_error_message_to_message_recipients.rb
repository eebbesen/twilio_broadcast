class AddStatusAndErrorMessageToMessageRecipients < ActiveRecord::Migration[6.0]
  def change
    add_column :message_recipients, :status, :string
    add_column :message_recipients, :error_code, :integer
    add_column :message_recipients, :error_message, :string
  end
end

class AddRemovedToRecipients < ActiveRecord::Migration[6.0]
  def change
    add_column :recipients, :removed, :boolean, default: false

    Recipient.update_all(removed: false)
  end
end

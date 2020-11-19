class AddRemovedToRecipients < ActiveRecord::Migration[6.0]
  def change
    add_column :recipients, :removed, :boolean
  end
end

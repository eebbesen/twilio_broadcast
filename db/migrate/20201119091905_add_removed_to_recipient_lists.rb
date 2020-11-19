class AddRemovedToRecipientLists < ActiveRecord::Migration[6.0]
  def change
    add_column :recipient_lists, :removed, :boolean, default: false

    RecipientList.update_all(removed: false)
  end
end

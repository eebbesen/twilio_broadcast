class AddUserIdToRecipientss < ActiveRecord::Migration[6.0]
  def change
    add_column :recipients, :user_id, :integer
  end
end

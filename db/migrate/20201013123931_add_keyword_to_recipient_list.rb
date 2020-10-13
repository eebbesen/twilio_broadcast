class AddKeywordToRecipientList < ActiveRecord::Migration[6.0]
  def change
    add_column :recipient_lists, :keyword, :string
  end
end

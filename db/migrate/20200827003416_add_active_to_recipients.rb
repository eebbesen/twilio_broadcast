class AddActiveToRecipients < ActiveRecord::Migration[6.0]
  def change
    add_column :recipients, :active, :boolean, default: true
  end
end

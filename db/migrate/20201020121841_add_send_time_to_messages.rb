class AddSendTimeToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :send_time, :datetime
  end
end

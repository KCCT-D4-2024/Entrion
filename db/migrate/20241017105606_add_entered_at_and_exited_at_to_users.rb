class AddEnteredAtAndExitedAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :entered_at, :datetime
    add_column :users, :exited_at, :datetime
  end
end

class RemoveNullFromEmailFromUsers < ActiveRecord::Migration[7.2]
  def change
    change_column :users, :email, :string, null: true
  end
end

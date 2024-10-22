class AddTotalScoreToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :total_score, :integer, null: false, default: 0
    add_column :users, :total_score_updated_at, :datetime
  end
end

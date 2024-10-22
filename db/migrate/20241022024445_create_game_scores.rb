class CreateGameScores < ActiveRecord::Migration[7.2]
  def change
    create_table :game_scores do |t|
      t.integer :score
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end

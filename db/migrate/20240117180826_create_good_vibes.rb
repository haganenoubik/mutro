class CreateGoodVibes < ActiveRecord::Migration[7.0]
  def change
    create_table :good_vibes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
    add_index :good_vibes, [:user_id, :playlist_id], unique: true
  end
end

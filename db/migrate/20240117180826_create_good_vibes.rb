class CreateGoodVibes < ActiveRecord::Migration[7.0]
  def change
    create_table :good_vibes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end

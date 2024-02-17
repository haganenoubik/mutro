class CreateMoods < ActiveRecord::Migration[7.0]
  def change
    create_table :moods do |t|
      t.string :name
      t.string :image_filename

      t.timestamps
    end
  end
end

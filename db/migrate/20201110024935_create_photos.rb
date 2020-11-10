class CreatePhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :photos do |t|
      t.integer :user_id
      t.string :image_id
      t.string :camera
      t.string :lens
      t.string :shutter_speed
      t.string :f_value
      t.string :iso
      t.string :item
      t.text :comment

      t.timestamps
    end
  end
end

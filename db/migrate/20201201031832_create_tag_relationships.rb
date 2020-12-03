class CreateTagRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :tag_relationships do |t|
      t.integer :photo_id
      t.integer :tag_id

      t.timestamps
    end
  end
end

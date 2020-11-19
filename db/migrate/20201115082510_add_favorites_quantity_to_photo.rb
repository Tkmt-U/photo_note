class AddFavoritesQuantityToPhoto < ActiveRecord::Migration[5.2]
   def change
     add_column :photos, :favorites_quantity, :integer
   end
 end
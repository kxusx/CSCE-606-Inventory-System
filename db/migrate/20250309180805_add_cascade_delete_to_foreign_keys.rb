class AddCascadeDeleteToForeignKeys < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :bins, :locations
    add_foreign_key :bins, :locations, on_delete: :cascade

    remove_foreign_key :items, :locations
    add_foreign_key :items, :locations, on_delete: :cascade
  end
end

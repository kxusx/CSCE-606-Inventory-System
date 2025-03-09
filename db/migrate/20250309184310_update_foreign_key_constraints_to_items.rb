class UpdateForeignKeyConstraintsToItems < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :items, :bins
    add_foreign_key :items, :bins, on_delete: :cascade
  end
end

class AddLocationToBins < ActiveRecord::Migration[8.0]
  def change
    remove_column :bins, :location, :string
    add_reference :bins, :location, foreign_key: true
  end
end

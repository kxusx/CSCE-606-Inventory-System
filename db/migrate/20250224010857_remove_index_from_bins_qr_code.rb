class RemoveIndexFromBinsQrCode < ActiveRecord::Migration[8.0]
  def change
    remove_index :bins, name: "index_bins_on_qr_code"
  end
end

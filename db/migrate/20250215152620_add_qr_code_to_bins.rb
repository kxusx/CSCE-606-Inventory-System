class AddQrCodeToBins < ActiveRecord::Migration[8.0]
  def change
    add_column :bins, :qr_code, :string
    add_index :bins, :qr_code, unique:true # garantee unique qr values
  end
end

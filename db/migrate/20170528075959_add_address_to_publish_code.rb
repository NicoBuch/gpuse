class AddAddressToPublishCode < ActiveRecord::Migration[5.0]
  def change
    add_column :publish_codes, :address, :text
  end
end

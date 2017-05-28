class AddDeliveredToFrame < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :delivered, :boolean, default: false
  end
end

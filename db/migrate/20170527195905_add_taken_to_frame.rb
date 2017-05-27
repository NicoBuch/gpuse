class AddTakenToFrame < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :taken, :boolean, default: false
  end
end

class AddCompletedToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :completed, :boolean, default: false
  end
end

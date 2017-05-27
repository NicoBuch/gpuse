class AddTimeElapsedToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :time_elapsed, :integer, limit: 8
  end
end

class AddWeisEarnedToFrames < ActiveRecord::Migration[5.0]
  def change
    add_column :frames, :weis_earned, :integer, limit: 8
  end
end

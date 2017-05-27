class AddSubscriberToFrame < ActiveRecord::Migration[5.0]
  def change
    add_reference :frames, :subscriber, foreign_key: true
  end
end

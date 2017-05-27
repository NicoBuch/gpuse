class AddWorkingToSubscriber < ActiveRecord::Migration[5.0]
  def change
    add_column :subscribers, :working, :boolean, default: false
  end
end

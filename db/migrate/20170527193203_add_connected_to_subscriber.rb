class AddConnectedToSubscriber < ActiveRecord::Migration[5.0]
  def change
    add_column :subscribers, :connected, :boolean, default: false
  end
end

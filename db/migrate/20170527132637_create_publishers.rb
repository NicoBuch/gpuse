class CreatePublishers < ActiveRecord::Migration[5.0]
  def change
    create_table :publishers do |t|
      t.string :username, unique: true, null: false
      t.string :password, null: false
      t.string :eth_address, unique: true

      t.timestamps
    end
    add_index :publishers, :username, unique: true
  end
end

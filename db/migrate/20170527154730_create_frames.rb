class CreateFrames < ActiveRecord::Migration[5.0]
  def change
    create_table :frames do |t|
      t.belongs_to :published_code, foreign_key: true
      t.integer :index
      t.string :file

      t.timestamps
    end
  end
end

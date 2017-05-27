class CreatePublishedCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :published_codes do |t|
      t.text :code
      t.belongs_to :publisher, foreign_key: true

      t.timestamps
    end
  end
end

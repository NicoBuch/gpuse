class AddFileToPublishedCode < ActiveRecord::Migration[5.0]
  def change
    add_column :published_codes, :file, :string
  end
end

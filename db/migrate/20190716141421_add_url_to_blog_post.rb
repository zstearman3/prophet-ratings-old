class AddUrlToBlogPost < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :url_path, :string
    add_index :blog_posts, :url_path, unique: true
  end
end

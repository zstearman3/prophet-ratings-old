class AddPublishedToBlogPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :blog_posts, :published, :boolean, default: false
    add_reference :blog_posts, :user, foreign_key: true
  end
end

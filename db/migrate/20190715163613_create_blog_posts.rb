class CreateBlogPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.string :subtitle
      t.text :preview
      t.text :body
      t.string  :image_url
      t.date :date
      t.references :team, foreign_key: true
      t.timestamps
    end
  end
end

class BlogPostsController < ApplicationController
  require 'nokogiri'
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy, :drafts]
  
  def index
    @blog_posts = BlogPost.where(published: true).order(date: :desc).paginate(page: params[:page], per_page: 10)
  end
  
  def show
    @blog_post = BlogPost.find(params[:id])
  end
  
  def new
    @blog_post = BlogPost.new
  end
  
  def create
    @blog_post = BlogPost.new(post_params)
    @blog_post.date = Date.today
    @blog_post.user = current_user
    if @blog_post.save
      blog_text = Nokogiri::HTML(@blog_post.body).text
      max_length = blog_text[0..1000].rindex(' ')
      @blog_post.preview = blog_text[0..max_length]
      if @blog_post.save
        flash[:info] = "Blog Post Created!"
        redirect_to @blog_post
      else
        render 'new'
      end
    else
      render 'new'
    end
  end
  
  def edit 
    @blog_post = BlogPost.find(params[:id])
  end
  
  def update
    @blog_post = BlogPost.find(params[:id])
    @blog_post.date = Date.today
    @blog_post.user = current_user
    if @blog_post.update(post_params)
      blog_text = Nokogiri::HTML(@blog_post.body).text
      max_length = blog_text[0..1000].rindex(' ')
      @blog_post.preview = blog_text[0..max_length]
      if @blog_post.save
        flash[:info] = "Blog Post Updated!"
        redirect_to @blog_post
      else
        render 'edit'
      end
    else
      render 'edit'
    end
  end
  
  def drafts
    @blog_posts = BlogPost.where(published: false).order(date: :desc).paginate(page: params[:page], per_page: 10)
  end

  private
    def post_params
      params.require(:blog_post).permit(:title, :subtitle, :body, :image_url, :date, :published, :team_id)
    end
end

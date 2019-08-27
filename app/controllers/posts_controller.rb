class PostsController < ApplicationController
  def index
    @posts = Post.all
    @post = Post.new
    @all_ranks = Post.find(Like.group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
    now = Time.current
    @monthly_ranks = Post.find(Like.where(created_at: (now.ago(30.days))..(Time.now)).group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
    @daily_ranks = Post.find(Like.where(created_at: (now.ago(24.hours))..(Time.now)).group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
    @minitly_ranks = Post.find(Like.where(created_at: (now.ago(60.seconds))..(Time.now)).group(:post_id).order('count(post_id) desc').limit(3).pluck(:post_id))
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true)
  end

  def show
    @post = Post.find(params[:id])
    @like = Like.new
  end

  def hashtags
    @tag = Tag.find_by(name: params[:name])
    @posts = @tag.posts
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update(post_params)
    redirect_to :action => :"index"
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to :action => :"index"
  end

  private
  def post_params
    params.require(:post).permit(:content)
  end
end

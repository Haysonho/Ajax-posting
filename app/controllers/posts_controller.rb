class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :destroy]

  def index
    @posts = Post.order("id DESC").all
  end

     def like
     @post = Post.find(params[:id])
     unless @post.find_like(current_user)  # 如果已经按讚过了，就略过不再新增
       Like.create( :user => current_user, :post => @post)
     end
   end

   def unlike
     @post = Post.find(params[:id])
     like = @post.find_like(current_user)
     like.destroy

     render "like"
   end

   def collect
        @post = Post.find(params[:id])
        unless @post.find_collect(current_user)  # 如果已经收藏过了，就略过不再新增
          Collect.create( :user => current_user, :post => @post)
        end
      end

      def cancelcollect
        @post = Post.find(params[:id])
        cancelcollect = @post.find_collect(current_user)
        cancelcollect.destroy
        render "collect"
      end
  def create
    @post = Post.new(post_params)
    @post.user = current_user
    @post.save

  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

  end



  protected

  def post_params
    params.require(:post).permit(:content)
  end
end

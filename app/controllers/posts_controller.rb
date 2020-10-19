class PostsController < ApplicationController
    def index
        @posts = Post.newsfeed_posts(current_user)
        @post = current_user.posts.build
        @comment = current_user.comments.build
    end

    def new
        @post = current_user.posts.build
    end

    def create
        @post = current_user.posts.build(post_params)
        @post.save
        redirect_to posts_path
    end

    private

    def post_params
        params.require(:post).permit(:title, :body)
    end

end

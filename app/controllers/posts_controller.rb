class PostsController < ApplicationController
    def index
        @posts = Post.all
        @post = current_user.posts.build
    end

    def new
        @post = current_user.posts.build
    end

    def create
        @post = current_user.posts.build(post_params)
        @post.save
        redirect_to root_path
    end

    private

    def post_params
        params.require(:post).permit(:title, :body)
        #I dont think the error is here as commenting this out causes the same error 
        # do i need user id here and in the form as hidden field?
        # <%= post_form.hidden_field :user_id, value: current_user.id %><br>
    end
end

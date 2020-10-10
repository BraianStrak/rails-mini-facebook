class CommentsController < ApplicationController
    def create
        @comment = current_user.comments.build(comment_params)
        @comment.save
        redirect_to posts_path
    end
    
    private

    def comment_params
        params.require(:comment).permit(:body, :post_id)
    end
end 

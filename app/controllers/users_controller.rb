class UsersController < ApplicationController
    def show
        #profile page 
        @user = current_user
        @posts = current_user.posts
    end

    def index
    end
end

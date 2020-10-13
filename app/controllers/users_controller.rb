class UsersController < ApplicationController
    def show
        #profile page 
        @user = current_user
        @posts = current_user.posts
    end

    def index
        @users = User.all
        @friend_request = current_user.friend_requests_as_sender.build
    end
end

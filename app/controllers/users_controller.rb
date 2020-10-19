class UsersController < ApplicationController
    def show
        #profile page 
        @user = current_user
        @posts = current_user.posts
    end

    def index
        @users = User.all
        @friendship = Friendship.new
        @friend_request = current_user.friend_requests_as_sender.build
        @received_friend_requests = current_user.friend_requests_as_receiver.all
    end

    private 
end

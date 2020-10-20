class UsersController < ApplicationController
    def show
        #profile page 

        #need to put this when the user first registers, but to do this we need to override the devise controller.
        #RegistrationMailer.welcome_email(current_user).deliver_now

        @user = current_user
        @posts = current_user.posts
    end

    def index
        @users = User.included_in_request(current_user)
        @friendship = Friendship.new
        @friend_request = current_user.friend_requests_as_sender.build
        @received_friend_requests = current_user.friend_requests_as_receiver.all
    end

    private 
end

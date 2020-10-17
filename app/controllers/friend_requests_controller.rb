class FriendRequestsController < ApplicationController
    def create
        #This and the other one return that user is missing. both do. 
        @friend_request = FriendRequest.create(sender_id: current_user.id, receiver_id: params[:receiver_id])
        @friend_request.save
        redirect_to users_path
    end
end

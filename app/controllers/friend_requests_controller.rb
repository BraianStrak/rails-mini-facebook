class FriendRequestsController < ApplicationController
    def create
        @friend_request = current_user.friend_request_as_senders.build(friend_request_params)
        @friend_request.save
        redirect_to users_path
    end

    private

    def friend_request_params
        params.require(:friend_request).permit(:receiver_id)
    end
end

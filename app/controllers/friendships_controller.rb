class FriendshipsController < ApplicationController
    def create
        @friendship = Friendship.create(friend_a_id: current_user.id, friend_b_id: params[:friend_b_id])
        @friendship.save
        redirect_to users_path
    end
end

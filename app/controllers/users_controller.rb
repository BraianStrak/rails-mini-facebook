class UsersController < ApplicationController
    def show
        #profile page 
        @user = current_user.id
    end

    def index
    end
end

class UsersController < ApplicationController
    def show
        #profile page 
        @user = current_user
    end

    def index
    end
end

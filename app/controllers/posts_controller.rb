class PostsController < ApplicationController
    def index
        @posts = newsfeed_posts
        @post = current_user.posts.build
        @comment = current_user.comments.build
    end

    def new
        @post = current_user.posts.build
    end

    def create
        @post = current_user.posts.build(post_params)
        @post.save
        redirect_to posts_path
    end

    private

    def post_params
        params.require(:post).permit(:title, :body)
    end

    def friends
        friends = Array.new
        if current_user.friendships
          current_user.friendships.each do |friendship|
            #if the current user is not friend A
            if friendship.friend_a_id != current_user.id
              #add the user to the friends list
              friends.push(User.find(friend_a_id))
            else
              #add the other user to the friends list
              friends.push(User.find(friend_b_id))
            end
          end
          friends.push(current_user)
          friends
        end
    end
    
    def newsfeed_posts
        posts = Array.new

        #if you put this back into user model, change this back to current_user.friends
        friends.each do |friend|
            friend.posts.each do |post|
                posts.push(post)
            end
        end
        posts
    end  
end

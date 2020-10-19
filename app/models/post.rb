class Post < ApplicationRecord
    belongs_to :user
    has_many :likes
    has_many :comments

    def self.newsfeed_posts(user)
        posts = Array.new

        #if you put this back into user model, change this back to current_user.friends
        User.user_friends(user).each do |friend|
            friend.posts.each do |post|
                posts.push(post)
            end
        end
        posts
    end  
end

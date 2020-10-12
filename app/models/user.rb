class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  has_many :likes
  has_many :comments

  has_many :friend_requests_as_sender, 
    foreign_key: :sender_id, 
    class_name: :FriendRequest
  has_many :friend_requests_as_receiver, 
    foreign_key: :receiver_id, 
    class_name: :FriendRequest

  #This lets us tell rails to look for user friendships where they are either friend A or friend B
  has_many :friendships, ->(user) { where("friend_a_id = ? OR friend_b_id = ?", user.id, user.id) }


end

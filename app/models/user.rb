class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[facebook]
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
  

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20] #this might just be password, or encrypted_password
      user.name = auth.info.name   # assuming the user model has a name
      #user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      #user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.user_friends(user)
    friendships = Friendship.all
    current_user_friendships = Array.new
    friends = Array.new
    friendships.each do |friendship|
        if friendship.friend_a_id == user.id
            current_user_friendships.push(friendship)
        elsif friendship.friend_b_id == user.id
            current_user_friendships.push(friendship)
        end
    end

    if current_user_friendships.any?
      current_user_friendships.each do |friendship|
        #if the current user is not friend A
        if friendship.friend_a_id != user.id
          #add the user to the friends list
          friends.push(User.find(friendship.friend_a_id))
        else
          #add the other user to the friends list
          friends.push(User.find(friendship.friend_b_id))
        end
      end
    end
    friends.push(user)
    friends
  end

  def self.included_in_request(user)
    excluded_user_ids = Array.new
    friendships = Friendship.all
    if(user.friend_requests_as_sender != nil)
      friend_requests = user.friend_requests_as_sender
    end

    excluded_user_ids.push(user.id)

    if friend_requests.any?
      friend_requests.each do |request|
        #if the receiver is in there then exclude them from the friend request list
        excluded_user_ids.push(request.receiver_id)
      end
    end
    
    if friendships.any?
      friendships.each do |friendship|
          # if the user is in the friendship
          if(friendship.friend_a_id == user.id || friendship.friend_b_id == user.id)
            #exclude both IDs in the friendship unless the ID is already excluded
            unless excluded_user_ids.include? friendship.friend_a_id
              excluded_user_ids.push(friendship.friend_a_id)
            end

            unless excluded_user_ids.include? friendship.friend_b_id
              excluded_user_ids.push(friendship.friend_b_id)
            end
          end
      end
    end

    #find a way to exclude them without deleting all users in the DB.
    users = User.where.not(id: excluded_user_ids)
    users
  end

  #This works, but can also override the devise registrations controller. 
  after_create :send_admin_mail
  def send_admin_mail
    RegistrationMailer.welcome_email(self).deliver_now
  end

  
end

class User < ActiveRecord::Base
  # note :admin is excluded, so malicatious user cannot send a PUT
  # requset to make arbitraty users admins.
  attr_accessible :name, :username, :email, :password, :password_confirmation, :course, :school, :status, :image, :remote_image_url
  has_secure_password

  default_scope :order=> :name
  mount_uploader :image, ImageUploader
  has_many :microposts, :dependent=> :destroy
  has_many :relationships, :foreign_key=> "follower_id",
    :dependent=> :destroy
  has_many :followed_users, :through=> :relationships, :source=> :followed

  has_many :reverse_relationships, :foreign_key=> "followed_id",
    :class_name=> "Relationship",
    :dependent=> :destroy
  has_many :followers, :through=> :reverse_relationships, :source=> :follower

  has_many :sent_messages, :class_name=> "Message", :foreign_key=> :from_user_id,
    :dependent=> :destroy
  has_many :received_messages, :class_name=> "Message", :foreign_key=> :to_user_id,
    :dependent=> :destroy


  has_many :evaluations, :class_name=> "RSEvaluation", :as=> :source

  has_reputation :votes, :source=> {:reputation=> :votes, :of=> :microposts}, :aggregated_by=> :sum

  def voted_for?(feed_item)
    evaluations.where(:target_type=> feed_item.content, :target_id=> feed_item.id).present?
  end


  VALID_EMAIL_REGEX =/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_USERNAME_REGEX = /\A\w+\z/

  validates :name,  :presence=> true,
    :length=> { :maximum=> 50 }

  validates :username, :presence=> true,
    :format=>  { :with=> VALID_USERNAME_REGEX },
    :length=> { :maximum=> 15 },
    :uniqueness=> { :case_sensitive=> true }

  validates :email, :presence=>   true,
    :format=>     { :with=> VALID_EMAIL_REGEX },
    :uniqueness=> { :case_sensitive=> false }

  # automatically created the virtual attribute password_confirmation
  validates :password, :presence=> true,
    :length=> { :minimum=> 6 }
  validates :password_confirmation, :presence=> true

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  # method to search all Users by username.
  # uses method 'paginate', which applies finder options
  # (github.com/mislav/will_paginate/blob/master/lib/will_paginate/active_record.rb)
  def self.search(username, page)
    paginate :page=> page, :conditions=> ['username like ?', "%#{username}%"]
  end

  def feed
    Micropost.from_users_followed_by(self)
  end 

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(:followed_id=> other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user).destroy
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.base64.tr("+/", "-_")
    end
end
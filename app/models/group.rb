class Group < ActiveRecord::Base
  has_many :votes
  has_many :grants
  has_many :memberships, :dependent => :destroy
  has_many :users, :through => :memberships
  has_many :comments, :as => :commentable  
  
  validates_presence_of :name, :purpose
end

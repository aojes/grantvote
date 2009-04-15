class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :grant
  has_many :comments, :as => :commentable 
  
  validates_presence_of     :user_id, :group_id, :grant_id, :cast
  validates_inclusion_of    :cast, :in => %w(yea nay)
  validates_uniqueness_of   :user_id, :scope  => :grant_id

end

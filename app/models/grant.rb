class Grant < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :votes
  has_many :comments, :as => :commentable
                                    
  validates_presence_of :name, :proposal, :amount
  validates_numericality_of :amount, :integer_only => true, :minimum => 10,
            :message => "can be an integer value greater than or equal to 10"
    
end

class Grant < ActiveRecord::Base
  belongs_to :group
  has_many :votes
  has_many :comments, :as => :commentable
                                    
  validates_presence_of :name, :proposal, :amount
  validates_numericality_of :amount  
  # TODO round decimal amounts to the nearest integer  


                                  
end

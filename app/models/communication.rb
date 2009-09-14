class Communication < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :content
  validates_length_of :content, :in => 1..210

  attr_accessible :content
end


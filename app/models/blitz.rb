class Blitz < ActiveRecord::Base
  require "hpricot"
  
  DUES = 5
  MIN_AWARD = 10
  MIN_NAME, MAX_NAME = [2, 60]
  
  # GREEN, BLUE, RED, SCALE = ["E6EFC2", "DFF4FF", "FBE3E4", "DFDFDF"]
  GREEN, BLUE, RED, SCALE = ["66C966", "628BB5", "E57474", "E0E0E0"]
  SESSION_BAR_CHART_X, SESSION_BAR_CHART_Y  = [198, 32]
  AWARD_CHART_X, AWARD_CHART_Y = [92, 50]
  
  belongs_to :user
  belongs_to :blitz_fund
  has_many :votes
  has_many :comments, :as => :commentable

  has_permalink :name, :update => true
  
  validates_presence_of :name, :proposal, :amount
  validates_length_of :name, :in => MIN_NAME..MAX_NAME,
              :message => "can be #{MIN_NAME} to #{MAX_NAME} characters"
  validates_numericality_of :amount, :only_integer => true, 
    :greater_than_or_equal_to => MIN_AWARD, 
    :message => "can be an integer value, greater than or equal to $#{MIN_AWARD}"
  
  # TODO
  # validates_attachment_presence :photo <= this includes validations
    
  before_save :adapt_objects
  # before_save :adapt_links
  
  named_scope :awarded,  :conditions => {:awarded => true}
  named_scope :denied, :conditions => {:final => true, :awarded => false}
  named_scope :session,  :conditions => {:final => false}
  named_scope :chronological, :order => "created_at ASC"
  
 
  def finalizable?
    votes.yea.count == self.votes_win or votes.nay.count == self.votes_win + 1
  end
  
  def passes?
    votes.yea.count == self.votes_win
  end 

  def award!
    transaction do
      update_attributes!(:final => true, :awarded => true)
      blitz_fund.deduct_funds!(amount)
      user.cycle_interest!(amount)
    end
  end

  def deny!
    update_attributes!(:final => true, :awarded => false)
  end  
  
  def final_message
    if finalizable?
      if passes?
        "Grant awarded!"
      else
        "Grant denied."
      end
    else
      nil
    end
  end
  
  def limit_message
    user.blitzes.session.count > 1 ?  
      "You may only have one blitz grant in session at a time. " : nil
  end  
  
  def to_param
    permalink
  end

  private  
    
    # try to keep the media objects from breaking the layout
    # will require a more powerful solution to strip other content (i.e., JS)  
    def adapt_objects
      unless media.blank?
        # strip as much HTML & JS as we can
        self.media = Hpricot(media).at("object").to_html
        media.gsub!(/<script.*>.*<\/script>/, '').to_s
        
        
        a = media.include?("http://www.youtube.com/")
        b = media.include?("http://www.youtube-nocookie.com/")
        c = media.include?("http://www.viddler.com/")
        d = media.include?("http://vimeo.com/")
        
        if media.include?("height=") and media.include?("width=")
          if a or b # YouTube
            media.gsub!(/width=\"\d+\"/, 'width="437"')
            media.gsub!(/height=\"\d+\"/, 'height="350"')
          elsif c   # Viddler
            media.gsub!(/width=\"\d+\"/, 'width="437"')
            media.gsub!(/height=\"\d+\"/, 'height="288"')
            media.gsub!(/<param(\s)name=\"flashvars\"(\s)value=\"autoplay=t\"(\s)\/>/, '')
            media.gsub!(/(\s)flashvars=\"autoplay=t\"/, '')
          elsif d   # Vimeo
            media.gsub!(/width=\"\d+\"/, 'width="437"')
            media.gsub!(/height=\"\d+\"/, 'height="246"')
          end
        else
          self.media = ""
        end
      end      
      true 
    end  
    
    # not used presently while using h(content) in the views
    # defer
    def adapt_links
      a = proposal.include?("</a>")
      proposal.gsub!(/<a.+?href/, '<a rel="nofollow" target="_blank" href') if a      
      true
    end
end


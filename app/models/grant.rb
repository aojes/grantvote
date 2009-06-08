class Grant < ActiveRecord::Base
  require "hpricot"
  
  AWARD_THRESHOLD, AWARD_THRESHOLD_PCT = [0.500, 50]
  
  MIN_AWARD = 5
  MIN_NAME, MAX_NAME = [2, 60]
  
  # GREEN, BLUE, RED, SCALE = ["E6EFC2", "DFF4FF", "FBE3E4", "DFDFDF"]
  GREEN, BLUE, RED, SCALE = ["66C966", "628BB5", "E57474", "E0E0E0"]
  SESSION_BAR_CHART_X, SESSION_BAR_CHART_Y  = [198, 32]
  AWARD_CHART_X, AWARD_CHART_Y = [92, 50]
  
  belongs_to :group
  belongs_to :user
  has_many :votes
  has_many :comments, :as => :commentable

  has_permalink :name
  
  has_attached_file :photo, #:default_url => "/images/defaults/grant_small.png",  
    :styles => {
        :thumb   => "32x32#", 
        :small   => "48x48#",
        :medium  => "75x75#",
        :large   => "92x92#", 
        :display => "256x256>" 
      },
   :url  => "/assets/grants/:id/:style/:basename.:extension",
   :path => ":rails_root/public/assets/grants/:id/:style/:basename.:extension"
   
  validates_attachment_size :photo, :less_than => Group::MAX_FILE_SIZE
  validates_attachment_content_type :photo, 
                       :content_type => ['image/jpeg', 'image/gif', 'image/png']
 
  validates_presence_of :name, :proposal, :amount
  validates_length_of :name, :in => MIN_NAME..MAX_NAME,
              :message => "length can be #{MIN_NAME} to #{MAX_NAME} characters"
  validates_numericality_of :amount, :only_integer => true, 
    :greater_than_or_equal_to => MIN_AWARD, 
    :message => "can be an integer value greater than or equal to $#{MIN_AWARD}"
  
  # TODO
  # validates_attachment_presence :photo <= this includes validations
    
  before_save :adapt_objects
  # before_save :adapt_links
  
  named_scope :awarded,  :conditions => {:awarded => true}
  named_scope :defeated, :conditions => {:final => true, :awarded => false}
  named_scope :session,  :conditions => {:final => false}
  named_scope :user_group_session, lambda { |*args|
    {  :conditions => 
          { :user_id => args.first, :group_id => args.second, :final => false } 
    }
  }
  named_scope :chronological, :order => "created_at ASC"

  def voters
    group.memberships.voters.count
  end

  def vote_threshold
    voters * AWARD_THRESHOLD 
  end

  def finalizable?
    passes? || denies?
  end

  def passes?
    votes.yea.count > vote_threshold
  end

  def denies?
    votes.nay.count > vote_threshold
  end

  def award!
    transaction do
      update_attributes!(:final => true, :awarded => true)
      group.deduct_funds!(amount)
      group.memberships.find_by_user_id(user).cycle_membership!(amount)
    end
  end

  def deny!
    update_attributes!(:final => true, :awarded => false)
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
            media.gsub!(/width=\"\d+\"/, 'width="425"')
            media.gsub!(/height=\"\d+\"/, 'height="344"')
          elsif c   # Viddler
            media.gsub!(/width=\"\d+\"/, 'width="437"')
            media.gsub!(/height=\"\d+\"/, 'height="288"')
            media.gsub!(/<param(\s)name=\"flashvars\"(\s)value=\"autoplay=t\"(\s)\/>/, '')
            media.gsub!(/(\s)flashvars=\"autoplay=t\"/, '')
          elsif d   # Vimeo
            media.gsub!(/width=\"\d+\"/, 'width="427"')
            media.gsub!(/height=\"\d+\"/, 'height="240"')
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


class Grant < ActiveRecord::Base

  AWARD_THRESHOLD, AWARD_THRESHOLD_PCT = [0.500, 50]

  MIN_AWARD = 10
  MIN_NAME, MAX_NAME = [2, 60]

  GREEN, BLUE, RED, SCALE = ["66C966", "628BB5", "E57474", "E0E0E0"]
  SESSION_BAR_CHART_X, SESSION_BAR_CHART_Y  = [198, 32]
  AWARD_CHART_X, AWARD_CHART_Y = [92, 50]

  belongs_to :group
  belongs_to :user
  belongs_to :membership
  has_many :votes

  define_index do
    indexes proposal
    indexes awarded
    indexes :name, :sortable => true
  end

  has_permalink :name, :update => true

  validates_presence_of :name, :proposal, :amount
  validates_length_of :name, :in => MIN_NAME..MAX_NAME,
              :message => "length can be #{MIN_NAME} to #{MAX_NAME} characters"
  validates_numericality_of :amount, :only_integer => true,
    :greater_than_or_equal_to => MIN_AWARD,
    :message => "can be an integer value greater than or equal to $#{MIN_AWARD}"

  # before_save :adapt_objects
  # before_save :adapt_links

  named_scope :awarded,  :conditions => {:awarded => true}
  named_scope :recent,   :order => "updated_at ASC"
  named_scope :defeated, :conditions => {:final => true, :awarded => false}
  named_scope :session,  :conditions => {:final => false, :session => true}
  named_scope :writeboard,  :conditions => {:final => false, :session => false}
  named_scope :user_group_session, lambda { |*args|
    {  :conditions =>
          { :user_id => args.first, :group_id => args.second,
            :final => false, :session => true }
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
      update_attributes!(:final => true, :awarded => true, :session => false)
      group.deduct_funds!(amount)
      group.memberships.find_by_user_id(user).cycle_membership!(amount)
      user.notifications.create!(
        :event   => 'Win',
        :url     => 'url baby!'
      )
    end
  end

  def deny!
    transaction do
      update_attributes!(:final => true, :awarded => false, :session => false)
      user.notifications.create!(
        :event   => 'Loss',
        :url     => 'url baby!'
      )
    end
  end

  def session_reset
    if session and votes.count.zero?
      update_attributes!(:session => false)
    end
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


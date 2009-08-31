class Credit < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :user_id

  before_update :conversions

  VALUES = {
    :pebble =>  1,
    :bead   =>  3,
    :button =>  9,
    :pen    => 27,
    :shell  =>  3,
    :pearl  =>  9,
    :ribbon => 27,
    :laurel => 81 }

  IMAGE_PATH = "/images/cred"

  DIR = {
    :pebble => "/pebble/",
    :bead   => "/bead_ab092ebwc2/",
    :button => "/button_hqp730qnc3/",
    :pen    => "/pen_itngh284h4/",
    :shell  => "/shell_lp524wmos5/",
    :pearl  => "/pearl_hw8bc34mx6/",
    :ribbon => "/ribbon_ab8025uen7/",
    :laurel => "/laurel_eg236qrad8/"
   }

  IMAGE_NAMES = {
    :pebble => "1_pebble.jpg",
    :bead   => "2_bead.jpg",
    :button => "3_button.jpg",
    :pen    => "4_pen.jpg",
    :shell  => "5_shell.jpg",
    :pearl  => "6_pearl.jpg",
    :ribbon => "7_ribbon.jpg",
    :laurel => "8_laurel.jpg"
   }

  named_scope :leaders, :order => "points DESC", :limit => 100

  def conversions

    if (self.pebbles % 3).zero? && !self.pebbles.zero?
      self.beads   += 1
      self.pebbles -= 3
    end

    if (self.beads   % 3).zero? && !self.beads.zero?
      self.buttons += 1
      self.beads   -= 3
    end

    if (self.buttons % 3).zero? && !self.buttons.zero?
      self.pens    += 1
      self.buttons -= 3
    end

    if (self.pens    % 3).zero? && !self.pens.zero?
      self.ribbons += 1
      self.pearls  += 1
      self.shells  += 1
      self.pens     = 1
    end

    if (self.shells  % 3).zero? && !self.shells.zero?
      self.pearls  += 1
      self.shells  -= 3
    end

    if (self.pearls  % 3).zero? && !self.pearls.zero?
      self.ribbons += 1
      self.pearls  -= 3
    end

    if (self.ribbons % 3).zero? && !self.ribbons.zero?
      self.laurels += 1
      self.ribbons -= 3
    end

  end

end


class Credit < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :user_id
  
  IMAGE_PATH = "/images/cred"
  
  DIR = { 
    :pebble => "/pebble/", 
    :bead   => "/bead_ab092ebwc2/",   # this image is too imposing for its place
    :button => "/button_hqp730qnc3/", # use for bead
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


end

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
    
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:p, html_escape(flash[msg.to_sym]), 
        :id => "flash-#{msg}", 
        :class => "rounded") unless flash[msg.to_sym].blank?
    end
    messages
  end

  # Replacement for Rails' default button_to helper
  # using HTML button element rather than HTML input element
  # Note use of <span><em> for styling
  def button_to(name, options = {}, html_options = {})
    html_options = html_options.stringify_keys
    convert_boolean_attributes!(html_options, %w( disabled ))
   
    method_tag = ''
    if (method = html_options.delete('method')) && %w{put delete}.include?(method.to_s)
      method_tag = tag('input', :type => 'hidden', :name => '_method', :value => method.to_s)
    end
   
    form_method = method.to_s == 'get' ? 'get' : 'post'
   
    request_token_tag = ''
    if form_method == 'post' && protect_against_forgery?
      request_token_tag = tag(:input, :type => "hidden", :name => request_forgery_protection_token.to_s, :value => form_authenticity_token)
    end
   
    if confirm = html_options.delete("confirm")
      html_options["onclick"] = "return #{confirm_javascript_function(confirm)};"
    end
   
    url = options.is_a?(String) ? options : self.url_for(options)
    name ||= url
   
    html_options.merge!("type" => "submit", "value" => name)
   
    "<form method=\"#{form_method}\" action=\"#{escape_once url}\" class=\"button-to\"><div>" +
      method_tag + content_tag("button", "<span><em>" +name+ "</em></span>", html_options) + 
      request_token_tag + "</div></form>"
  end
  
  def submit_button(name, lite = false)
    if lite 
     # %(<button type="submit"><span class="lite-span"><em class="lite-em">) + name + 
     # %(</em></span></button>)
      %(<button class="lite" type="submit"><span><em>) + name + 
      %(</em></span></button>)
    else 
      %(<button type="submit"><span><em>) + name + 
      %(</em></span></button>)
    end
  end


  
  def following_friendships(user)
    user.friendships.collect do |following|
      following unless following.friend.friendships.exists?(:friend_id => user)
    end.compact
  end
  
  def follower_friendships(user)
    user.inverse_friends.collect do |follower|
      follower unless user.friendships.exists?(:friend_id => follower)
    end.compact
  end
  
  def blitz_voter?(user)
    user.blitz_interest == true
  end
  
  def find_group(permalink)
    Group.find_by_permalink(permalink)
  end
    
  def find_group_id(permalink)
    Group.find_by_permalink(permalink).id
  end        
  
  def find_profile_id(permalink)
    Profile.find_by_permalink(permalink).id
  end        
  
  def find_grant_id(permalink)
    Grant.find_by_permalink(permalink).id
  end
  
  def user_cred_images(user, size = "small", limit = nil)
    compilation = user_cred_image_url_set(user.credit.pebbles, user.credit.beads, user.credit.buttons, user.credit.pens, user.credit.shells, user.credit.pearls, user.credit.ribbons, user.credit.laurels, size)
    if limit
      compilation.values_at(0..3).join
    else
      compilation.values_at(0..23).join
    end
  end
  
  def user_cred_image_url_set(p, b, bu, pe, sh, per, r, l, size)
    pebbles, beads, buttons, pens = "","","",""
    shells, pearls, ribbons, laurels = "","","",""
    total = p + b + bu + pe + sh + per + r + l
    
    compilation = []

    l.times do
      compilation << "<img alt='laurel' src='#{cred_image_path(:laurel, size)}' title='laurel'/>"
    end
    r.times do
      compilation << "<img alt='ribbon' src='#{cred_image_path(:ribbon, size)}' title='ribbon'/>"
    end    
    per.times do
      compilation << "<img alt='pearl' src='#{cred_image_path(:pearl, size)}' title='pearl'/>"
    end
    sh.times do
      compilation << "<img alt='shell' src='#{cred_image_path(:shell, size)}' title='shell'/>"
    end
    pe.times do
      compilation << "<img alt='pen' src='#{cred_image_path(:pen, size)}' title='pen'/>"
    end
    bu.times do
      compilation << "<img alt='button' src='#{cred_image_path(:button, size)}' title='button'/>"
    end
    b.times do
      compilation << "<img alt='bead' src='#{cred_image_path(:bead, size)}' title='bead'/>"
    end
    p.times do
      compilation << "<img alt='pebble' src='#{cred_image_path(:pebble, size)}' title='pebble'/>"
    end
    compilation
  end  
  
  def cred_image_path(type, size)
    prefix = Credit::IMAGE_PATH
    case type.to_s
      when "pebble" 
        path = Credit::DIR[:pebble] + "#{size}/#{Credit::IMAGE_NAMES[:pebble]}"
      when "bead" 
        path = Credit::DIR[:bead]   + "#{size}/#{Credit::IMAGE_NAMES[:bead]}"
      when "button" 
        path = Credit::DIR[:button] + "#{size}/#{Credit::IMAGE_NAMES[:button]}"
      when "pen" 
        path = Credit::DIR[:pen]    + "#{size}/#{Credit::IMAGE_NAMES[:pen]}"
      when "shell" 
        path = Credit::DIR[:shell]  + "#{size}/#{Credit::IMAGE_NAMES[:shell]}"
      when "pearl" 
        path = Credit::DIR[:pearl]  + "#{size}/#{Credit::IMAGE_NAMES[:pearl]}"
      when "ribbon" 
        path = Credit::DIR[:ribbon] + "#{size}/#{Credit::IMAGE_NAMES[:ribbon]}"
      when "laurel" 
        path = Credit::DIR[:laurel] + "#{size}/#{Credit::IMAGE_NAMES[:laurel]}" 
    end
    prefix + path
  end 
  
  def session_bar_chart_image(grant)
    votes_yea = grant.votes.yea.count
    votes_nay = grant.votes.nay.count
    session_voting_pool = (1 + grant.amount / Blitz::DUES).to_f * 2
    
    green = (votes_yea / session_voting_pool).round(2) * 100
      red = (votes_nay / session_voting_pool).round(2) * 100
    scale = 100 # session_voting_pool < 100 ? "100" : session_voting_pool
    ## ?
    # scale == "100" ? blue = 100 - (green + red) : Group::AWARD_THRESHOLD_PCT
    blue = 100 - green - red
    chart_url = "http://chart.apis.google.com/chart?cht=bhs" +
    "&amp;chs=#{Grant::SESSION_BAR_CHART_X}x#{Grant::SESSION_BAR_CHART_Y}" +
    "&amp;chd=t:#{green}|#{blue}|#{red}|#{scale}" +
    "&amp;chco=#{Grant::GREEN},#{Grant::BLUE},#{Grant::RED},#{Grant::SCALE}" +
    "&amp;chf=bg,s,EDEDED"
    accessible_tally(grant, chart_url, votes_yea, votes_nay, session_voting_pool)
  end
  
  # for bar chart image alt & title attributes
  def accessible_tally(grant, chart_url, yeas, nays, session_voting_pool)
    votes_yea = "#{yeas} Yea, "
    votes_nay = nays > 0 ? "#{nays} Nay, " : ''
    votes = votes_yea + votes_nay
    awaiting = (session_voting_pool - yeas - nays).to_i + 1
    status = grant.final   ? 
             grant.awarded ? 
                 "Awarded" : "Denied" : "Awaiting #{awaiting}"
    tally = votes + status
    
    %(<img alt="#{tally}" title="#{tally}" src="#{chart_url}" class="votes" />)
    
  end   
  
  def session_bar_chart_url(grant)
    voters_count = grant.group.memberships.voters.count
    voters       = voters_count.zero? ? 1 : voters_count
    votes_yea    = grant.votes.yea.count
    votes_nay    = grant.votes.nay.count
    
    green = ((votes_yea.to_f / voters.to_f) * 100).to_i
      red = ((votes_nay.to_f / voters.to_f) * 100).to_i
    scale = voters < 100 ? "100" : voters
    scale == "100" ? blue = 100 - (green + red) : Group::AWARD_THRESHOLD_PCT
    "http://chart.apis.google.com/chart?cht=bhs" +
    "&amp;chs=#{Grant::SESSION_BAR_CHART_X}x#{Grant::SESSION_BAR_CHART_Y}" +
    "&amp;chd=t:#{green}|#{blue}|#{red}|#{scale}" +
    "&amp;chco=#{Grant::GREEN},#{Grant::BLUE},#{Grant::RED},#{Grant::SCALE}" +
    "&amp;chf=bg,s,EDEDED"
  end
  
  def group_accessible_tally(grant)
    voters    = grant.group.memberships.voters.count
    yea       = grant.votes.yea.count
    nay       = grant.votes.nay.count
    awaiting  = voters - yea - nay
    votes_yea = "#{yea} Yea, "
    votes_nay = nay > 0 ? "#{nay} Nay, " : ''
    votes = votes_yea + votes_nay
    status = grant.final   ? 
             grant.awarded ? 
                 "Awarded" : "Denied" : "Awaiting #{awaiting}"
    votes + status
  end 
  
  # returns the default image for instance if none defined
  def user_defined_image(instance, size, options = {})
    if instance.photo.file?
      image_tag instance.photo.url(size), options
    else
      type = instance.class.name.downcase
      image_tag "/images/defaults/#{type}_#{size}.png", options
    end
  end
  
  def show_link(name, options = {}, html_options= nil)
    url = options.is_a?(String) ? 
                        options : url_for(options.merge({:only_path => false}))
    current_url = url_for(:action => @current_action, :only_path => false)
  
    if url == current_url
     content_tag(:li, link_to(name,options, html_options ),  :class => "active")
    else

	   content_tag(:li,  link_to(name,options, html_options ), :class => "normal")
    end
  end
  
  def award_total
    grant_awards = Grant.find_all_by_awarded(true).collect {|g| g.amount}.sum
    blitz_awards = Blitz.find_all_by_awarded(true).collect {|b| b.amount}.sum
    grant_awards + blitz_awards
  end     

  def truncate_words(text, length = 15, end_string = ' …')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end

end

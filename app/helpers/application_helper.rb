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
      messages << content_tag(:p, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}", :class => "rounded") unless flash[msg.to_sym].blank?
    end
    messages
  end

  # Replacement for Rails' default button_to helper
  # using HTML button element rather than HTML input element
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
  
  def submit_button(name) 
    %(<button type="submit" onclick="this.blur();"><span><em>) + name + 
    %(</em></span></button>)
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
  
  def compile_and_render_user_cred_images(user, size = "small")
    user_cred_image_url_set(user.credit.pebbles, user.credit.beads, user.credit.buttons, user.credit.pens, user.credit.shells, user.credit.pearls, user.credit.ribbons, user.credit.laurels, size)
  end
  
  def user_cred_image_url_set(p, b, bu, pe, sh, per, r, l, size = "small")
    pebbles, beads, buttons, pens = "","","",""
    shells, pearls, ribbons, laurels = "","","",""
    p.times do
      pebbles += "<img alt='pebble' src='#{cred_image_path(:pebble, size)}' title='pebble'/>&nbsp; "
    end
    b.times do
      beads += "<img alt='bead' src='#{cred_image_path(:bead, size)}' title='bead'/>&nbsp; "
    end
    bu.times do
      buttons += "<img alt='button' src='#{cred_image_path(:button, size)}' title='button'/>&nbsp; "
    end
    pe.times do
      pens += "<img alt='pen' src='#{cred_image_path(:pen, size)}' title='pen'/>&nbsp; "
    end
    sh.times do
      shells += "<img alt='shell' src='#{cred_image_path(:shell, size)}' title='shell'/>&nbsp; "
    end
    per.times do
      pearls += "<img alt='pearl' src='#{cred_image_path(:pearl, size)}' title='pearl'/>&nbsp; "
    end
    r.times do
      ribbons += "<img alt='ribbon' src='#{cred_image_path(:ribbon, size)}' title='ribbon'/>&nbsp; "
    end
    l.times do
      laurels += "<img alt='laurel' src='#{cred_image_path(:laurel, size)}' title='laurel'/>&nbsp; "
    end
    
    pebbles + beads + buttons + pens + shells + pearls + ribbons + laurels
    
  end  
  
  def cred_image_path(type, size = "small")
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
end

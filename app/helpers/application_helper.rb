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
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
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
    %(<button type="submit", onclick="this.blur();"><span><em>) + name + 
    %(</em></span></button>)
  end
  
  def find_group_id(permalink)
    Group.find_by_permalink(permalink).id
  end        
end

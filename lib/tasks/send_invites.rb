#!script/runner

require 'action_controller/integration'
 
session = ActionController::Integration::Session.new

 
session.get '/invitation/send_invites'

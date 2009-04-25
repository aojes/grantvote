module GrantsHelper
    
  # returns current grants voted into session
  def group_session_grants(grants)
    grants.collect! { |grant|
      grant unless grant.final or grant.votes.count.zero? or
                     Vote.exists?(:user_id => current_user, :grant_id => grant)
    }.compact
  end
  
  def session_bar_chart_url(grant)
    voters    = grant.group.memberships.voters.count
    votes_yea = grant.votes.yea.count
    votes_nay = grant.votes.nay.count
    
    green = ((votes_yea.to_f / voters.to_f) * 100).to_i
      red = ((votes_nay.to_f / voters.to_f) * 100).to_i
    scale = voters < 100 ? "100" : voters
    scale == "100" ? blue = 100 - (green + red) : Group::AWARD_THRESHOLD_PCT
    "http://chart.apis.google.com/chart?cht=bhs" +
    "&amp;chs=#{Grant::SESSION_BAR_CHART_X}x#{Grant::SESSION_BAR_CHART_Y}" +
    "&amp;chd=t:#{green}|#{blue}|#{red}|#{scale}" +
    "&amp;chco=#{Grant::GREEN},#{Grant::BLUE},#{Grant::RED},#{Grant::SCALE}"
  end
    
end





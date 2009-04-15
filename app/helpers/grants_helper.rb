module GrantsHelper
    
  # returns grants not voted on by members
  def forum(grants)
    # TODO write scopes
    grants.collect! { |grant|
      grant unless Vote.exists?(:user_id => current_user, :grant_id => grant)
    }
    grants.compact
  end
  
  # returns grants voted on but the vote is not final
  def review(grants)
    grants.collect! { |grant|
      grant if Vote.exists?(:user_id => current_user, :grant_id => grant)
    }.compact
  end
  
  # return authority earned towards winning grant
  def grant_authority(grant)
    vote_count = grant.votes.count.to_f
    if vote_count.zero?
      return 0
    else
      progress = 0.0 
      grant.votes.each do |vote| 
        progress += vote.authority if vote.cast == "yea"
        progress -= vote.authority if vote.cast == "nay"
      end
  
    end
    progress / vote_count
  end
  
  # percent of authority required to win grant
  def percent_authorized(authority)
    authority > Group::AWARD_THRESHOLD ? 100 : authority < 0 ?
                                           0 : (authority * 200).floor
  end
  
end

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
  
end

class Authority

  # Can authority voting be optional?
  
  def pays(user, group, dues)
    
    # adjust authority of all principal members
    # assign membership.principal = true
    # assign membership.authority
    
  end
  
  def withdraws(user, group, dues)

    # adjust authority of all principal members
    # assign membership.principal = false
    # clear membership.authority

  end
  
  def awards(grant)
   # unclear . . .
   # add group statistic?
  end
  
  def expires(grant)
  end
  
  def defeats(grant)
  end
  
end

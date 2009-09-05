module HomeHelper

  def activities(user, list = [])
    mutual_friendships(user).each do |m|
      # new blitzes
      m.friend.blitzes.session.collect! do |b|
        list << b if !b.votes.exists?(:user_id => user)
      end
      # won blitzes
      m.friend.blitzes.awarded.each do |b|
        list << b
      end
      # joined groups
      m.friend.groups.reverse.collect! do |g|
        list << g.memberships.find_by_user_id(m.friend) # unless g.memberships.
                                                      #exists?(:user_id => user)
      end
      # won grants
      m.friend.grants.collect! do |g|
        list << g if g.session or g.awarded
      end
    end
    @list = list.sort {|a,b| b.updated_at <=> a.updated_at }.
         paginate(:page => params[:news], :per_page => 9)
  end

  def activity_link(instance, photo = false)
    if photo
      case instance.class.name
        when 'Membership'
          link_to user_defined_image(instance.group, :thumb,
            :alt => instance.group.name), group_path(instance.group)
        when 'Grant'
          link_to user_defined_image(instance.group, :thumb, :alt => instance.name),
            group_grant_path(instance.group, instance)
        when 'Blitz'
          # link_to 'Blitz Icon', blitz_path(instance)
          link_to image_tag('/images/icons/blitz_32.png'), blitz_path(instance)
      end
    else
      case instance.class.name
        when 'Membership'
          link_to(instance.group.name, group_path(instance.group))
        when 'Blitz'
          link_to(instance.name, blitz_path(instance))
        when 'Grant'
          link_to(instance.name, group_grant_path(instance.group, instance))
      end
    end
  end

  def group_message(membership)
    if membership.class.name.eql?('Membership')
      if membership.role.eql?('creator')
      'created'
        # TODO add more logic for promotions etc
      else
      'joined'
      end
    else
      nil
    end
  end

  def grant_message(grant)
    if grant.awarded
      '<strong>won!</strong>'
    elsif !grant.final
      if grant.class.name.eql?('Blitz')
        '<strong>blitzes</strong>'
      else
        '<strong>writes</strong>'
      end
    end
  end

end


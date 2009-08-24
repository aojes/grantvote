module HomeHelper

  def activities(user, list = [])
    mutual_friendships(user).each do |m|
      # new blitzes
      m.friend.blitzes.session.collect! do |b|
        list << b if !b.votes.count.zero? && b.votes.find_by_user_id(user).nil?
      end
      # won blitzes
      m.friend.blitzes.awarded.each do |b|
        list << b
      end
      # joined groups
      m.friend.groups.reverse.collect! do |g|
        list << g.memberships.find_by_user_id(m.friend)
      end
    end
    @list = list.sort {|a,b| b.updated_at <=> a.updated_at }.
              paginate(:page => params[:page], :per_page => 6)
  end

  def group_message(membership)
    if membership.class.name == 'Membership'
      'joined'
      # TODO add more logic for creating groups, promotions etc
    else
      nil
    end
  end

  def grant_message(grant)
    if grant.awarded and grant.final
      'won'
    elsif !grant.final
      'created'
    else
      nil
    end
  end

  def activity_link(instance, photo = false)
    if photo
      case instance.class.name.downcase
        when 'membership'
          link_to user_defined_image(instance.group, :thumb,
            :alt => instance.group.name), group_path(instance.group)
        when 'grant'
          link_to user_defined_image(instance, :thumb, :alt => instance.name),
            group_grant_path(instance.group, instance)
        when 'blitz'
          # link_to 'Blitz Icon', blitz_path(instance)
          link_to image_tag('/images/icons/blitz_32.png'), blitz_path(instance)
      end
    else
      case instance.class.name.downcase
        when 'membership'
          link_to(instance.group.name, group_path(instance.group))
        when 'blitz'
          link_to(instance.name, blitz_path(instance))
        when 'grant'
          link_to(instance.name, group_grant_path(instance.group, instance))
      end
    end
  end
end


class Ability
  include CanCan::Ability

#  def initialize(user)
#    puts "=========== #{user.role.rolename.inspect}"
#    can :read, :all
#  end

  def initialize(user)
    if user.role? :admin
      can :manage, :all
    else
      can :read, :all
    end
  end

end
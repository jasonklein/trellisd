class Ability
  include CanCan::Ability

  def initialize(user)


    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new(role: :guest) # guest user (not logged in)
      if user.role? :admin
        can :read, :all
        can :manage, User, id: user.id
        can :destroy, User
        can :manage, UserFlag
        can :manage, PostFlag
        can :manage, Post, user_id: user.id
        can :read, Post
        can :manage, Connection, connecter_id: user.id
        can :manage, Connection, connectee_id: user.id   
        can :manage, Message, sender_id: user.id
        can :manage, Message, recipient_id: user.id   
      elsif user.role? :basic
        can :manage, User, id: user.id
        can :read, User
        can :create, UserFlag
        can :create, PostFlag
        can :manage, Post, user_id: user.id
        can :read, Post
        can :category_index, Post
        can :manage, Connection, connecter_id: user.id
        can :manage, Connection, connectee_id: user.id
        can :manage, Message, sender_id: user.id
        can :manage, Message, recipient_id: user.id
      elsif user.role? :guest
        can :read, Post
        can :category_index, Post
      end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end

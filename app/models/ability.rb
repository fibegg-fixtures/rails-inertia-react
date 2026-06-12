class Ability
  include CanCan::Ability

  # Edit this for your authorization rules. Out of the box: signed-in users
  # can read/write their own ActiveStorage uploads. Tweak to match your model.
  def initialize(user)
    if user.present?
      can :manage, ActiveStorage::Blob
    else
      can :read, ActiveStorage::Blob
    end
  end
end

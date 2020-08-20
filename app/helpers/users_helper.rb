module UsersHelper
  def avatar_for(user, options = { size: 250 })
    size = options[:size]
    if user.avatar?
      image_tag user.avatar.url(:thumb), width: size
    else
      image_tag "default.jpg", width: size
    end
  end
end

module UsersHelper
  def avatar_for(user, options = { size: 250 })
    size = options[:size]
    if user.avatar?
      image_tag user.avatar.url(:thumb), width: size, :style => "border-radius: 50%;"
    else
      image_tag "default.jpg", width: size, :style => "border-radius: 50%;"
    end
  end
end

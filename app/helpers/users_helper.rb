module UsersHelper
  def get_user_avatar user
    if user.avatar
      user.avatar.url
    else
      "default.png"
    end
  end
end

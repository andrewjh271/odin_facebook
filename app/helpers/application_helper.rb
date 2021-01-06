module ApplicationHelper
  def valid_url?(url)
    url.match?(/^(http)s?:\/\//)
  end

  def avatar_thumbnail(user, element_class)
    display =
      if user.avatar.attached?
        image_tag url_for(user.avatar.variant(resize_to_fill: [50, 50, { gravity: 'Center' }])), class: element_class
      else
        "<div class='#{element_class}'></div>"
      end
    wrap_in_show_link(user, display)
  end

  def avatar(user, element_class)
    display =
      if user.avatar.attached?
        image_tag url_for(user.avatar), class: element_class
      else
        "<div class='#{element_class}'></div>"
      end
    wrap_in_show_link(user, display)
  end

  private

  def wrap_in_show_link(user, display)
    "<a href='#{user_path(user)}'>
      #{display}
    </a>".html_safe
  end
end
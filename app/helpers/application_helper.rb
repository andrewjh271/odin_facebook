module ApplicationHelper
  def valid_url?(url)
    url.match?(/^(http)s?:\/\//)
  end

  def avatar_thumbnail(user, element_class)
    display =
      if user.avatar.attached?
        image_tag user.avatar.variant(resize_to_fill: [80, 80, { gravity: 'Center' }]), class: element_class
      else
        "<div class='#{element_class}'></div>"
      end
    wrap_in_show_link(user, display)
  end

  def avatar(user, element_class)
    display =
      if user.avatar.attached?
        image_tag user.avatar, class: element_class
      else
        "<div class='#{element_class}'></div>"
      end
    wrap_in_show_link(user, display)
  end

  def friendship_indicator(user)
    display = 
      if current_user == user
        return
      elsif current_user.friends.include?(user)
        "#{button_to destroy_friendship_path,
             method: :delete,
             data: { confirm: "Really unfriend #{user.name}?" },
             params: { friend_a_id: user.id, friend_b_id: current_user.id },
             class: "unfriend" do
               "<i class='fas fa-user-minus'></i>".html_safe
             end}
        <i class='fas fa-user-friends'></i>"
      elsif invitation = current_user.friend_invitations.find_by(requester: user)
        "#{link_to delete_friend_request_path(invitation),
            method: :delete,
            class: 'delete-request delete-request-show',
            data: { confirm: "Delete #{invitation.requester.name}'s friend request?" } do
              "<i class='fas fa-user-times'></i>".html_safe
           end}
        #{link_to confirm_friend_request_path(invitation),
            method: :post,
            class: 'confirm-request' do
              "<i class='fas fa-user-check'></i>".html_safe
          end}"
      elsif current_user.requested_friends.include?(user)
        "<i class='far fa-clock'></i>"
      else
        button_to friend_requests_path,
          method: :post,
          class: 'add-friend',
          params: { recipient_id: user.id } do
            "<i class='fas fa-user-plus'></i>".html_safe
        end
      end
      display.html_safe
  end

  private

  def wrap_in_show_link(user, display)
    "<a href='#{user_path(user)}'>
      #{display}
    </a>".html_safe
  end
end
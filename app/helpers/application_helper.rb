module ApplicationHelper
  # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = "Progress"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # def unique_categories(all_posts)
  #   categories = []
  #   all_posts.each do |post|
  #     categories << post.category
  #   end
  #   categories.uniq!
  # end

  def replies(comment)
    Comment.where(replied_id: comment.id)
  end

  def user_image(user, options = { height: "60" })
    if user.profile_image.attached?
      image_tag user.profile_image, options
    elsif user.social_image_url
      image_tag user.social_image_url, options
    else
      image_tag "no_image.png", options
    end
  end
end

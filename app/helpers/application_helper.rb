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

  def admin_user?(user)
    if user == nil
      return false
    elsif user.admin?
      return true
    else
      return false
    end
  end

  def replies(comment)
    Comment.where(replied_id: comment.id)
  end
end

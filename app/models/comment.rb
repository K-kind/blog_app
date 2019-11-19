class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :micropost
  has_many :notifications, dependent: :destroy
  validates :content, presence: true, length: { maximum: 400 }

  def create_notification_comment!(current_user)
    # 返信コメントであれば、返信されたユーザーに通知
    if self.replied_id
      replied_user_id = Comment.find(self.replied_id).user_id
      if replied_user_id != current_user.id && replied_user_id != self.micropost.user_id
        save_notification_comment!(current_user, replied_user_id)
      end
    end
    unless current_user == self.micropost.user
      save_notification_comment!(current_user, self.micropost.user_id)
    end
  end

  def save_notification_comment!(current_user, receiver_id)
    notification = current_user.active_notifications.new(
      micropost_id: micropost_id,
      comment_id: id,
      receiver_id: receiver_id,
      action: 'comment'
    )
    notification.save if notification.valid?
  end
end

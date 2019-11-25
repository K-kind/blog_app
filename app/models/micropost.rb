class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 10000 }
  validates :content_string, presence: true, length: { maximum: 10000 }
  validates :title, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :category, presence: true, length: { maximum: 20 }
  attachment :post_image
  has_rich_text :content
  is_impressionable counter_cache: true
  has_one_attached :image

  def next
    user.microposts.where("id > ?", id).first
  end

  def prev
    user.microposts.where("id < ?", id).last
  end

  def self.search(search)
    return Micropost.all unless search
    Micropost.where(['title LIKE ? OR content_string LIKE ?', "%#{search}%", "%#{search}%"])
  end

  def create_notification_like!(current_user)
    temp = Notification.where(["sender_id = ? and receiver_id = ? and micropost_id = ? and action = ? ", current_user.id, user_id, id, 'like'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank? && (current_user != user)
      notification = current_user.active_notifications.new(
        micropost_id: id,
        receiver_id: user_id,
        action: 'like'
      )
      notification.save if notification.valid?
    end
  end

end

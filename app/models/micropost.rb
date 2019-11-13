class Micropost < ApplicationRecord
  belongs_to :user
  # default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1500 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :category, presence: true, length: { maximum: 20 }
  attachment :post_image
  has_rich_text :content

  def next
    user.microposts.where("id > ?", id).first
  end

  def prev
    user.microposts.where("id < ?", id).last
  end
end

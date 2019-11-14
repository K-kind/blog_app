class Micropost < ApplicationRecord
  belongs_to :user
  # default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 10000 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :category, presence: true, length: { maximum: 20 }
  attachment :post_image
  has_rich_text :content
  is_impressionable

  def next
    user.microposts.where("id > ?", id).first
  end

  def prev
    user.microposts.where("id < ?", id).last
  end

  def self.search(search)
    return Micropost.all unless search
    Micropost.where(['title LIKE ? OR content LIKE ?', "%#{search}%", "%#{search}%"])
  end

end

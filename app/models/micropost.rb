class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 1500 }
  # validate :post_image_size
  attachment :post_image

  # def post_image_size
  #   if post_image.size > 5.megabytes
  #     errors.add(:post_image, "should be less than 10MB")
  #   end
  # end
end

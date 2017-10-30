class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.micropost.max_content}
  validate :picture_size

  scope :order_by_created_at_desc, -> {order created_at: :desc}
  scope :feed, ->(following_ids, user_id){where "user_id IN (?) OR user_id = ?",
    following_ids, user_id}

  private

  def picture_size
    if picture.size > Settings.micropost.picture_size.megabytes
      errors.add :picture, t("should_be_less_than_5MB")
    end
  end
end

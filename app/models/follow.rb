
class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id }
  validate :not_self

  private
  def not_self
    errors.add(:base, "cannot follow self") if follower_id == followed_id
  end
end

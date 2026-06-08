class Article < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :title, presence: true
  validates :body, presence: true
  
  after_save :archive_if_reported

  private

  def archive_if_reported
    if reports_count >= 3 && !archived?
      update_column(:archived, true)
    end
  end
end

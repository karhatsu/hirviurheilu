class Announcement < ApplicationRecord
  validates :published, :presence => true
  validates :title, :presence => true
  validates :markdown, presence: true

  default_scope { order 'published desc' }
  scope :active, -> { where active: true }
  scope :front_page, -> { where front_page: true }
end

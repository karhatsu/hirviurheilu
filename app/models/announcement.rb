class Announcement < ActiveRecord::Base
  validates :published, :presence => true
  validates :title, :presence => true
  validates :content, :presence => true
  
  default_scope { order 'published desc' }
  scope :active, -> { where active: true }
  scope :front_page, -> { where front_page: true }
end

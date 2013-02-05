class Announcement < ActiveRecord::Base
  validates :published, :presence => true
  validates :title, :presence => true
  validates :content, :presence => true
  validates :active, :presence => true
end

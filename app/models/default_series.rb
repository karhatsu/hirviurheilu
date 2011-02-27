class DefaultSeries < ActiveRecord::Base
  has_many :default_age_groups

  validates :name, :presence => true

  def self.create_default_series
    df = create!(:name => 'S16')
    df.default_age_groups << DefaultAgeGroup.new(:name => 'T16', :min_competitors => 0)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'P16', :min_competitors => 0)
    create!(:name => 'M20')
    create!(:name => 'M')
    create!(:name => 'M40')
    create!(:name => 'M50')
    df = create!(:name => 'M60')
    df.default_age_groups << DefaultAgeGroup.new(:name => 'M65', :min_competitors => 3)
    df = create!(:name => 'M70')
    df.default_age_groups << DefaultAgeGroup.new(:name => 'M75', :min_competitors => 3)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'M80', :min_competitors => 3)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'M85', :min_competitors => 3)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'M90', :min_competitors => 3)
    create!(:name => 'N20')
    create!(:name => 'N')
    df = create!(:name => 'N40')
    df.default_age_groups << DefaultAgeGroup.new(:name => 'N50', :min_competitors => 3)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'N60', :min_competitors => 3)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'N70', :min_competitors => 3)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'N75', :min_competitors => 3)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'N80', :min_competitors => 3)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'N85', :min_competitors => 3)
    df.default_age_groups << DefaultAgeGroup.new(:name => 'N90', :min_competitors => 3)
  end
end

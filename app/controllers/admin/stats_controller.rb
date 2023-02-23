class Admin::StatsController < Admin::AdminController
  before_action :validate_sports

  def index
    @is_admin_stats = true
    @races_by_year = query "select extract(isoyear from start_date) as year#{districts_column}, count(*) from races r #{districts_join} #{sport_condition} group by extract(isoyear from start_date)#{districts_column} order by extract(isoyear from start_date)#{districts_column}"
    @competitors = query "select extract(isoyear from start_date) as year#{districts_column}, count(*) from races r inner join series s on r.id = s.race_id inner join competitors c on s.id = c.series_id #{districts_join} #{sport_condition} group by extract(isoyear from start_date)#{districts_column} order by extract(isoyear from start_date)#{districts_column}"
    @people = query "select extract(isoyear from c.created_at) as year#{districts_column}, count(distinct(last_name, first_name)) from competitors c inner join series s on c.series_id = s.id inner join races r on s.race_id = r.id #{districts_join} where extract(isoyear from c.created_at)>=2011  #{sport_condition 'and'} group by extract(isoyear from c.created_at)#{districts_column} order by extract(isoyear from c.created_at)#{districts_column}"
  end

  private

  def validate_sports
    return unless params[:sport_key]
    params[:sport_key].each do |sport_key|
      raise "Unknown sport: #{sport_key}" unless Sport::ALL_KEYS.include?(sport_key)
    end
  end

  def query(sql)
    ActiveRecord::Base.connection.execute sql
  end

  def sport_condition(keyword = 'where')
    params[:sport_key] ? "#{keyword} r.sport_key in (#{params[:sport_key].map{|sport_key| "'#{sport_key}'"}.join(',')})" : ''
  end

  def districts_join
    params[:districts] ? "inner join districts d on r.district_id = d.id" : ''
  end

  def districts_column
    params[:districts] ? ", d.short_name" : ''
  end
end

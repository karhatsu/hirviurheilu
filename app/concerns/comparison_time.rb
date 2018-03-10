module ComparisonTime
  extend ActiveSupport::Concern

  def comparison_time_in_seconds(age_group, unofficials)
    @age_groups_hash ||= age_groups_for_comparison_time(unofficials)
    best_time_in_seconds(@age_groups_hash[age_group], unofficials)
  end

  private

  def best_time_in_seconds(age_groups, unofficials)
    @best_time_cache ||= Hash.new
    cache_key = age_groups.to_s + unofficials.to_s
    return @best_time_cache[cache_key] if @best_time_cache.has_key?(cache_key)
    conditions = { :no_result_reason => nil }
    conditions[:unofficial] = false if unofficials != Series::UNOFFICIALS_INCLUDED_WITH_BEST_TIME
    conditions[:age_group_id] = age_groups.map { |group| group ? group.id : [nil, 0] }.flatten if age_groups
    time = competitors.where(conditions).minimum(time_subtraction_sql)
    if time
      @best_time_cache[cache_key] = time.to_i
      return time.to_i
    else
      @best_time_cache[cache_key] = nil
      return nil
    end
  end

  def age_groups_for_comparison_time(unofficials)
    ordered_age_groups = age_groups.except(:order).order('name desc')
    return {} if ordered_age_groups.empty?

    # e.g. P17/T17 in series S17
    return children_series_hash ordered_age_groups if children_series?

    # e.g. N55, N60, N65 in series N50
    hash = hash_with_age_group_referring_to_comparison_groups(ordered_age_groups, unofficials)

    # nil (refers to main series) => [nil, all age groups with normal trip length]
    append_main_series_to_hash(hash, ordered_age_groups)
  end

  def children_series?
    name =~ /S[1-2][0-9]/
  end

  def children_series_hash(age_groups)
    hash = {}
    build_children_series_hash hash, age_groups, 'P'
    build_children_series_hash hash, age_groups, 'T'
    hash
  end

  def build_children_series_hash(hash, age_groups, gender_letter)
    ordered_age_groups = age_groups.select {|age_group| age_group.name[0] == gender_letter}.sort do |a, b|
      b.name[1..-1].to_i <=> a.name[1..-1].to_i
    end
    ordered_age_groups.each_with_index do |age_group, i|
      hash[age_group] = []
      ordered_age_groups[i..-1].each do |ag|
        hash[age_group] << ag
      end
    end
  end

  def hash_with_age_group_referring_to_comparison_groups(ordered_age_groups, unofficials)
    hash = Hash.new # { M75 => [M75], M70 => [M75, M70],... }
    competitors_count = 0
    to_same_pool = [] # age groups in the same pool use the same comparison time
    ordered_age_groups.each_with_index do |age_group, i|
      to_same_pool << age_group
      competitors_count += age_group.competitors_count(unofficials)
      if enough_competitors_for_own_comparison_time(age_group, competitors_count) ||
          last_age_group_with_different_trip_length(ordered_age_groups, i)
        add_groups_from_pool_to_hash(hash, ordered_age_groups, to_same_pool)
        to_same_pool = []
        competitors_count = 0
      end
    end
    add_groups_from_pool_to_hash(hash, ordered_age_groups, to_same_pool, include_main_series=true)
    hash
  end

  def enough_competitors_for_own_comparison_time(age_group, competitors_count)
    competitors_count >= age_group.min_competitors
  end

  def last_age_group_with_different_trip_length(ordered_age_groups, i)
    return false if i == ordered_age_groups.length - 1
    ordered_age_groups[i].shorter_trip != ordered_age_groups[i + 1].shorter_trip
  end

  def add_groups_from_pool_to_hash(hash, ordered_age_groups, groups_in_same_pool, include_main_series=false)
    groups_in_same_pool.each do |age_group|
      comparison_groups = []
      # pick older age groups
      ordered_age_groups.each do |older_group|
        break if groups_in_same_pool[0] == older_group
        comparison_groups << older_group if age_group.shorter_trip == older_group.shorter_trip
      end
      # pick age groups from the pool
      groups_in_same_pool.each { |pool_group| comparison_groups << pool_group }
      comparison_groups << nil if include_main_series
      hash[age_group] = comparison_groups
    end
  end

  def append_main_series_to_hash(hash, ordered_age_groups)
    hash[nil] = ordered_age_groups.select { |age_group| !age_group.shorter_trip }
    hash[nil] << nil
    hash
  end
end
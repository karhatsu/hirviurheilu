module ComparisonTime
  extend ActiveSupport::Concern

  def comparison_time_in_seconds(age_group, all_competitors)
    return best_time_in_seconds(nil, all_competitors) unless age_group
    @age_group_ids_hash ||= age_group_comparison_group_ids(all_competitors)
    best_time_in_seconds(@age_group_ids_hash[age_group], all_competitors)
  end

  private

  def best_time_in_seconds(age_group_ids, all_competitors)
    @best_time_cache ||= Hash.new
    cache_key = age_group_ids.to_s + all_competitors.to_s
    return @best_time_cache[cache_key] if @best_time_cache.has_key?(cache_key)
    conditions = { :no_result_reason => nil }
    conditions[:unofficial] = false unless all_competitors
    conditions[:age_group_id] = age_group_ids if age_group_ids
    time = competitors.where(conditions).minimum(time_subtraction_sql)
    if time
      @best_time_cache[cache_key] = time.to_i
      return time.to_i
    else
      @best_time_cache[cache_key] = nil
      return nil
    end
  end

  def age_group_comparison_group_ids(all_competitors)
    ordered_age_groups = age_groups.order('name desc')
    unless each_group_starts_with_same_letter(ordered_age_groups)
      return build_age_group_to_own_id_hash ordered_age_groups
    end

    groupped_age_groups, age_groups_without_enough_competitors =
        build_groupped_age_groups(ordered_age_groups, all_competitors)

    # hash: { age_group => [own age group id, another age group id, ...] }
    hash = build_hash_for_groups_without_enough_competitors(age_groups_without_enough_competitors)
    add_to_hash_groups_with_enough_competitors_including_older_age_groups hash, groupped_age_groups
  end

  def each_group_starts_with_same_letter(age_groups)
    return false if age_groups.empty?
    first_letter = age_groups[0].name[0]
    age_groups.each do |age_group|
      return false unless first_letter == age_group.name[0]
    end
    true
  end

  def build_age_group_to_own_id_hash(age_groups)
    hash = {}
    age_groups.each do |age_group|
      hash[age_group] = age_group.id
    end
    return hash
  end

  def build_groupped_age_groups(ordered_age_groups, all_competitors)
    groupped_age_groups = []
    groupped_age_group = []
    competitors_count = 0
    ordered_age_groups.each do |age_group|
      groupped_age_group << age_group
      competitors_count += age_group.competitors_count(all_competitors)
      if enough_competitors_for_own_reference_time(age_group, competitors_count)
        groupped_age_groups << groupped_age_group
        groupped_age_group = []
        competitors_count = 0
      end
    end
    return groupped_age_groups, groupped_age_group
  end

  def enough_competitors_for_own_reference_time(age_group, competitors_count)
    competitors_count >= age_group.min_competitors
  end

  def build_hash_for_groups_without_enough_competitors(age_groups_without_enough_competitors)
    hash = {}
    age_groups_without_enough_competitors.each do |age_group|
      hash[age_group] = nil
    end
    hash
  end

  def add_to_hash_groups_with_enough_competitors_including_older_age_groups(hash, groupped_age_groups)
    groupped_age_groups.each do |group|
      group.each do |age_group|
        ids = []
        own_group = false
        groupped_age_groups.each do |group2|
          group2.each do |age_group2|
            ids << age_group2.id
            own_group = true if age_group == age_group2
          end
          break if own_group
        end
        hash[age_group] = ids
      end
    end
    hash
  end
end
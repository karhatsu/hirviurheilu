json.(club, :id, :name, :long_name)
json.competitors_count club.competitors.size
json.can_be_removed club.can_be_removed?
json.officials_count club.race_rights.size

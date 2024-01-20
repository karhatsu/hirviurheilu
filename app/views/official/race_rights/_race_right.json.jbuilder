json.(race_right, :id, :user_id, :primary, :only_add_competitors, :new_clubs, :club_id)
json.first_name race_right.user.first_name
json.last_name race_right.user.last_name
json.email race_right.user.email
if race_right.club_id
  json.club do
    json.name race_right.club.name
  end
end

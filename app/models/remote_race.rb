class RemoteRace < ActiveResource::Base
  self.timeout = 20

  def self.build(race, email, password)
    attrs = race.attributes
    attrs.delete("id")
    attrs[:email] = email
    attrs[:password] = password
    return RemoteRace.new(attrs)
  end
end

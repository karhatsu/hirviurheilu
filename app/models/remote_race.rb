class RemoteRace < ActiveResource::Base
  self.site = "http://localhost:3000"
  self.timeout = 5
end

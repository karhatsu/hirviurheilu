class UserSession < Authlogic::Session::Base
  # required by authlogic to work with rails 3
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
end

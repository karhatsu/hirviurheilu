Given('I have an event {string}') do |name|
  @event = create :event, name: name
end

Given('the race belongs to the event') do
  @race.update_attribute :event_id, @event.id
end

Given('I open the smoke test domain') do
  visit ENV['URL'] || 'http://localhost:3000'
end

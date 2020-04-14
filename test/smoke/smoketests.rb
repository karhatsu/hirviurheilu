require 'nokogiri'
require 'open-uri'

@url = ARGV[0]
unless @url and @url.start_with?('http')
  puts "ruby smoketests.rb <@url>"
  exit
end

def error(msg)
  raise msg
end

def open_page(path='')
  full_path = @url + path
  puts "Opening page #{full_path}"
  @page = Nokogiri::HTML(open(full_path))
end

def find_xpath(xpath)
  element = @page.xpath(xpath)
  if element.empty?
    error "FAILURE: nothing found with given xpath"
  else
    puts "Element found"
  end
  element
end

def verify_text(element, expected)
  if expected && element.text.strip == expected
    puts "Text OK"
  elsif expected
    error "FAILURE: element text is '#{element.text}' vs. '#{expected}'"
  end
end

def verify_contains(xpath, text)
  puts "Expecting xpath #{xpath} to contain text '#{text}'"
  element = find_xpath(xpath)
  verify_text element, text
end

def find_link(xpath, text=nil)
  puts "Looking for link #{text ? "'" + text + "'" : 'with any text'} in xpath '#{xpath}'"
  element = find_xpath(xpath)
  verify_text element, text
  href = element.attribute('href').value
  puts "Link href: #{href}"
  href
end

def verify_http_status(path)
  full_path = @url + path
  uri = URI.parse(full_path)
  req = Net::HTTP::Get.new(uri.to_s)
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') {|http| http.request(req)}
  if res.header.code.to_i == 200
    puts "Status OK"
  else
    error "FAILURE: HTTP status #{res.header.code}"
  end
end

open_page('/')
verify_contains "//div[@class='body__on-top-title']", 'Hirviurheilu - Tulospalvelu Metsästäjäliiton urheilulajeille'
link_to_races = find_link "//div[@class='menu menu--main']/div[2]/a", 'Kilpailut'

open_page(link_to_races)
verify_contains "//div[@class='body__on-top-title']", 'Hirviurheilu - Kilpailut'

unless @url =~ /testi.hirviurheilu/
  link_to_last_page = find_link "//span[@class='last']/a"
  open_page(link_to_last_page)
end

link_to_race = find_link "(//div[@class='body__yield']//a[@class='card'])[last()]"

open_page(link_to_race)
link_to_results = find_link "//div[@id='series-links']//a[@class='button button--primary'][1]"

open_page(link_to_results)
link_to_pdf = find_link "//div[@class='buttons']//a[@class='button button--pdf']", 'Lataa tulokset PDF-tiedostona'
verify_http_status link_to_pdf

puts "--- ALL SMOKE TESTS PASSED FOR #{@url} ---"

require 'nokogiri'
require 'open-uri'

@url = ARGV[0]
unless @url and @url.start_with?('http')
  p "ruby smoketests.rb <@url>"
  exit
end

def error(msg)
  raise msg
end

def open_page(path='')
  full_path = @url + path
  p "Opening page #{full_path}"
  @page = Nokogiri::HTML(open(full_path))
end

def find_xpath(xpath)
  element = @page.xpath(xpath)
  if element.empty?
    error "FAILURE: nothing found with given xpath"
  else
    p "Element found"
  end
  element
end

def verify_text(element, expected)
  if expected and element.text == expected
    p "Text OK"
  elsif expected
    error "FAILURE: element text is #{element.text}"
  end
end

def verify_contains(xpath, text)
  p "Expecting xpath #{xpath} to contain text '#{text}'"
  element = find_xpath(xpath)
  verify_text element, text
end

def find_link(xpath, text=nil)
  p "Looking for link #{text ? "'" + text + "'" : 'with any text'} in xpath '#{xpath}'"
  element = find_xpath(xpath)
  verify_text element, text
  href = element.attribute('href').value
  p "Link href: #{href}"
  href
end

def verify_http_status(path)
  full_path = @url + path
  uri = URI.parse(full_path)
  req = Net::HTTP::Get.new(uri.to_s)
  res = Net::HTTP.start(uri.host, uri.port) {|http| http.request(req)}
  if res.header.code.to_i == 200
    p "Status OK"
  else
    error "FAILURE: HTTP status #{res.header.code}"
  end
end

open_page('/')
verify_contains "//div[@class='main_title']/span", 'Hirviurheilu - Hirvenhiihdon ja hirvenjuoksun tulospalvelu'
link_to_races = find_link "//div[@class='menu main_menu']/ul/li[2]/a", 'Kilpailut'

open_page(link_to_races)
verify_contains "//div[@class='main_title']/span", 'Hirviurheilu - Kilpailut'
link_to_race = find_link "//div[@class='main_content']//a[last()]"

open_page(link_to_race)
link_to_results = find_link "//table/tr[2]/td[4]/a[1]", 'Tulokset'

open_page(link_to_results)
link_to_pdf = find_link "//div[@class='action_box']/a", 'Lataa tulokset PDF-tiedostona'
verify_http_status link_to_pdf

p "All tests passed"

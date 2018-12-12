Gem::Specification.new do |s|
  s.name        = 'taleo-magic'
  s.version     = '1.2.3'
  s.date        = '2014-01-02'
  s.summary     = "Scraper and autofiller for taleo clients"
  s.description = "Scraper and autofiller for taleo clients"
  s.authors     = ["Gulnara Mirzakarimova"]
  s.email       = 'gulnara@jibe.com'
  s.files       = Dir["lib/**/*.rb"]

  s.add_development_dependency 'pry'
  s.add_dependency 'ascii'

end


sites = []

File.open('/tmp/publishers').each_line{ |s|
  /^.*:(.*)$/.match(s)
  sites << $1 if not sites.include?($1)
}

i=0
sites.each do |site|
  s = Site.new
  s.name = site
  s.save
  i += 1
end

puts "Loaded #{i} sites"



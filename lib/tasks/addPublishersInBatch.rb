
publishers = {}

File.open('/tmp/publishers').each_line{ |s|
  /^(.*):(.*)$/.match(s)
  publishers[$1] = $2 if not publishers.include?($1)
}

t = ResourceType.new
t.name = "computingElement"
t.save

t = ResourceType.find_by_name('computingElement')

i=0
j=0
publishers.each do |publisher,site|

  s = Site.find_by_name(site)
  if s
    r = Resource.new
    r.resource_type_id = t.id
    r.site_id = s.id
    r.name = "#{site}-CE"
    r.save
    r = Resource.find_by_name("#{site}-CE")
    i += 1
    if r
      p = Publisher.new
      p.hostname = publisher
      p.ip = '10.0.2.2' #CHANGEME
      p.resource_id = r.id
      p.save
      j += 1
    end
  end
  
end

puts "Loaded #{i} resources and #{j} publishers."



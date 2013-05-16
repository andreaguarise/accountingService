ip = ARGV[0]
file = ARGV[1]
if not ARGV[0]
  puts "Please specify the ip to be assigned to publishers as first argument."
  exit 1
else
  if not ARGV[1]
    puts "Please specify the publishers file name as second argument."
    exit 2
  end
  puts "Will be assigning ip:#{ip} to the publishers created from file:#{file}."
end
publishers = {}

File.open(file).each_line{ |s|
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
    i += 1 if r.save
    r = Resource.find_by_name("#{site}-CE")
    if r
      if not Publisher.find_by_hostname(publisher) 
        p = Publisher.new
        p.hostname = publisher
        p.ip = ip
        p.resource_id = r.id
        p.save
      j += 1
      end
    end
  end
  
end

puts "Loaded #{i} resources and #{j} publishers."



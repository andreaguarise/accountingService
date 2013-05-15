Publisher.find_each(:batch_size => 10) { |p|
  puts "#{p.hostname}:#{p.token}"
}

s = Site.joins(:apel_ssm_records).includes(:apel_ssm_records).group("sites.name").maximum(:endTime)
sorted = s.sort_by {|site,date| date}
sorted.each do |site,date|
  puts "#{site} --> #{Time.at(date)}"
end
# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
AccountingService::Application.initialize!


AccountingService::Application.configure do 
  config.itemsPerPage = 250
  config.itemsPerPageHTML = 25
  config.graphiteUrl = "http://localhost:80"
  config.graphiteGraphOpts = "&height=250&width=600"
  config.grafanaUrl = "http://dgas-dev-24.to.infn.it:8081"
  config.brokerInterface = "http://changeme:8161"
  config.brokerStomp = "changeme:61613"
  config.modAuthSecretFile = "/etc/faust/auth_tkt.conf"
  config.warningTimeInterval = 129600
end
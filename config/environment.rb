# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
AccountingService::Application.initialize!


AccountingService::Application.configure do 
  config.itemsPerPage = 250
  config.itemsPerPageHTML = 25
  config.graphiteUrl = "https://faust01.to.infn.it:8080"
  config.graphiteGraphOpts = "&height=250&width=600"
  config.grafanaUrl = "https://faust01.to.infn.it"
  config.brokerInterface = "http://dgas-broker.to.infn.it:8161"
  config.brokerStomp = "dgas-broker.to.infn.it:61613"
  config.modAuthSecretFile = "/etc/faust/auth_tkt.conf"
  config.warningTimeInterval = 129600
end

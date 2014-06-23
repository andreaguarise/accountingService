# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
AccountingService::Application.initialize!


AccountingService::Application.configure do 
  config.itemsPerPage = 250
  config.itemsPerPageHTML = 25
  config.graphiteUrl = "http://localhost:80"
  config.graphiteGraphOpts = "&height=250&width=600"
end
class MainController < ApplicationController
  skip_before_filter :userAuthenticate, :only => [:list]
  skip_before_filter :publisherAuthenticate
  def index
    @sites = Site.all
    @emiStorageBySite = EmiStorageRecord.group(:site).maximum(:endTime) #FIXME this should go through joins as for the other record types
    @emiStorageStatusBySite = {}
    @emiStorageBySite.each do |k,v|
      #@apelBySite[k] = Time.at(v)
     @emiStorageStatusBySite[k] = ((Time.now.to_i - Time.at(v).to_i) < 86400 ? "stateSuccess" : "stateFailure" )  
    end
    
    @apelBySite = Site.joins(:apel_ssm_records).group(:site_id).maximum(:endTime)
    @apelStatusBySite = {}
    @apelBySite.each do |k,v|
      #@apelBySite[k] = Time.at(v)
     @apelStatusBySite[k] = ((Time.now.to_i - Time.at(v).to_i) < 86400 ? "stateSuccess" : "stateFailure" )  
    end
    
    #@batchBySite = Site.joins(:batch_execute_records).group(:site_id).maximum(:recordDate)
    
    @cloudBySite = Site.joins(:cloud_records).group(:site_id).maximum(:endTime)
    @cloudStatusBySite = {}
    @cloudBySite.each do |k,v|
     @cloudStatusBySite[k] = ((Time.now.to_i - Time.at(v).to_i) < 86400 ? "stateSuccess" : "stateFailure" )  
    end
  end
  
  def list
    @sites = Site.all
  end
end

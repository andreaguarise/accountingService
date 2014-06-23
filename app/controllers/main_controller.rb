class MainController < ApplicationController
  skip_before_filter :publisherAuthenticate
  def index
    @sites = Site.all
    @emiStorageBySite = EmiStorageRecord.group(:site).count #FIXME this should go through joins as for the other record types
    @blahBySite = Site.joins(:blah_records).group(:site_id).count
    @batchBySite = Site.joins(:batch_execute_records).group(:site_id).count
    @cloudBySite = Site.joins(:cloud_records).group(:site_id).count
  end
end

class MainController < ApplicationController
  skip_before_filter :publisherAuthenticate
  def index
  end
end

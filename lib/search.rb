module Search
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    #include Search::InstanceMethods
    def search (key, name)
      if key and name
        find(:all, :conditions => ["#{key} LIKE ?" , "%#{name}%"])
      else
        find(:all)
      end
    end
    
    def orderByParms (default, params)
    params[:sort] = default if not params[:sort]
    order_string = params[:sort]
    order_string = order_string + " DESC" if params[:desc]
       self.order(order_string)
  end
    
  end

end
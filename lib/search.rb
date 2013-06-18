module Search
  def self.included(base) # :nodoc:
    base.extend ClassMethods
  end

  module ClassMethods
    #include Search::InstanceMethods
    def search (key, name)
      if key and name
        self.where(key => name).all
      else
        self.all
      end
    end
  end

end
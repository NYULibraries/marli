module Marli
  module Affiliations
    include Marli::ApplicationDetails
    
    def self.included(base)
    end
    
    # Retrieve the web text for this borrower affiliation based on the status
    def affiliation
      @affiliation ||= auth_types_collection[attrs[:bor_status]] unless attrs[:bor_status].nil?
    end

    # Get the affiliation title if it exists or the default text otherwise
    def affiliation_text
      return affiliation unless affiliation.nil?
      get_sanitized_detail("default_patron_type")
    end
        
    # Create a hash of :code => :web_text pairs for auth_types
    def auth_types_collection
      @auth_types_h ||= Rails.cache.fetch "auth_types_h", :expires_in => 24.hours do
        # Uses the Hash object to cast a mapped array as a hash
        Hash[auth_types.map {|x| [x["code"], x["web_text"]]}]
      end
    end

    # Collect a simple array of codes from auth_types
    def auth_types_array
      @auth_types_array ||= Rails.cache.fetch "auth_types_array", :expires_in => 24.hours do
        auth_types.collect {|x| x["code"] } 
      end
    end

    # Fetch auth_types from privileges guide
    # * Get patron statuses with access to the MaRLi sublibrary
    def auth_types 
      @auth_types ||= HTTParty.get("#{Settings.privileges.base_url}/patrons.json?sublibrary_code=#{Settings.privileges.marli_code}").body
    rescue Timeout::Error => e
      @error = e
      render 'user_sessions/timeout_error'
    end
    
    def attrs
      (defined?(current_user)) ? current_user.user_attributes : user_attributes
    end
    
  end
  
end
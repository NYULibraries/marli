module Marli
  module Affiliations
    include Marli::ApplicationDetails

    def self.included(base)
    end

    # Retrieve the web text for this borrower affiliation based on the status
    def affiliation
      @affiliation ||= auth_types_collection[attrs[:patron_status]] unless attrs[:patron_status].nil?
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
      @auth_types ||= HTTParty.get("#{ENV['PRIVILEGES_BASE_URL']}/patrons.json?sublibrary_code=#{ENV['PRIVILEGES_SUBLIBRARY_CODE']}").parsed_response
    rescue Timeout::Error => e
      @error = e
      render 'errors/timeout_error'
    end

    def attrs
      defined?(current_user) ? { patron_status: current_user.patron_status } : { patron_status: patron_status }
    end

  end

end

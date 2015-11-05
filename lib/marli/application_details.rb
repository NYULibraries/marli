module Marli
  module ApplicationDetails

    # Fetch application detail text by purpose
    def detail_by_purpose(purpose)
      ApplicationDetail.find_by_purpose(purpose)
    end

    # Sanitize detail
    def get_sanitized_detail(purpose)
     application_detail = detail_by_purpose(purpose)
     return application_detail.the_text.html_safe if text_exists?(purpose)
    end

    # Returns boolean for whether or not there exists application detail text for this purpose
    def text_exists?(purpose)
     text = detail_by_purpose(purpose)
     return !(text.nil? || text.the_text.empty?)
    end

  end
end

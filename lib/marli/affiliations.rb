module Marli
  module Affiliations
    include Marli::ApplicationDetails

    # Retrieve the web text for this borrower affiliation based on the status
    def affiliation
      @affiliation ||= auth_types_collection[attrs[:patron_status]] unless attrs[:patron_status].nil?
    end

    # Get the affiliation title if it exists or the default text otherwise
    def affiliation_text
      unless affiliation.nil?
        return affiliation
      else
        return get_sanitized_detail("default_patron_type") || I18n.t('default_patron_type')
      end
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
      @auth_types ||= hardcoded_auth_types #HTTParty.get("#{ENV['PRIVILEGES_BASE_URL']}/patrons.json?sublibrary_code=#{ENV['PRIVILEGES_SUBLIBRARY_CODE']}").parsed_response
    end

    def hardcoded_auth_types
      [{"id"=>88, "code"=>"nyu_ag_noaleph_NYU_Emeritus/Retired_Faculty", "original_text"=>nil, "web_text"=>"NYU Emeritus/Retired Faculty", "description"=>nil, "from_aleph"=>false, "created_at"=>"2010-02-03T02:00:38.000Z", "updated_at"=>"2017-04-07T17:27:36.000Z", "visible"=>true, "id_type"=>"NYU ID", "under_header"=>"NYU", "keywords"=>"Retired Faculty, Emeritus Faculty, Retired, Emeritus"}, {"id"=>28, "code"=>"50", "original_text"=>"NYU Full Time Faculty", "web_text"=>"NYU Full-time Faculty", "description"=>"", "from_aleph"=>true, "created_at"=>"2009-08-14T18:11:45.000Z", "updated_at"=>"2020-02-09T05:55:53.000Z", "visible"=>true, "id_type"=>"NYUcard", "under_header"=>"NYU", "keywords"=>"Faculty Full time, Full-time, Faculty"}, {"id"=>54, "code"=>"54", "original_text"=>"NYU PhD student", "web_text"=>"NYU PhD student", "description"=>"", "from_aleph"=>true, "created_at"=>"2009-08-14T18:11:46.000Z", "updated_at"=>"2020-02-09T05:55:55.000Z", "visible"=>true, "id_type"=>"NYU card", "under_header"=>"NYU", "keywords"=>"Phd, graduate student, Doctoral"}, {"id"=>84, "code"=>"nyu_ag_noaleph_NYU_SCPS_Degree_Faculty", "original_text"=>nil, "web_text"=>"NYU SPS Faculty", "description"=>"", "from_aleph"=>false, "created_at"=>"2009-11-10T01:31:06.000Z", "updated_at"=>"2017-04-07T17:36:25.000Z", "visible"=>true, "id_type"=>"NYU Card", "under_header"=>"NYU", "keywords"=>"SPS, Degree, Faculty, SPS Faculty"}, {"id"=>61, "code"=>"nyu_ag_noaleph_dental_faculty", "original_text"=>nil, "web_text"=>"NYU Dental Faculty", "description"=>"", "from_aleph"=>false, "created_at"=>"2009-08-30T16:13:22.000Z", "updated_at"=>"2017-04-07T18:23:32.000Z", "visible"=>true, "id_type"=>"NYUcard", "under_header"=>"NYU Dental School", "keywords"=>"Dental, Faculty, Dental Faculty, Dental School"}, {"id"=>59, "code"=>"nyu_ag_noaleph_law_faculty", "original_text"=>nil, "web_text"=>"NYU Law School Faculty", "description"=>"", "from_aleph"=>false, "created_at"=>"2009-08-29T02:36:46.000Z", "updated_at"=>"2017-04-07T18:24:52.000Z", "visible"=>true, "id_type"=>"NYUcard", "under_header"=>"NYU Law School", "keywords"=>"Law School Faculty, Law, Law School, NYU Law"}, {"id"=>63, "code"=>"nyu_ag_noaleph_medical_faculty", "original_text"=>nil, "web_text"=>"NYU School of Medicine Faculty", "description"=>"", "from_aleph"=>false, "created_at"=>"2009-08-30T16:28:11.000Z", "updated_at"=>"2019-11-19T18:15:32.000Z", "visible"=>true, "id_type"=>"NYU Card", "under_header"=>"NYU School of Medicine", "keywords"=>"Med School, NYU Med School, Medical School, NYU School of Medicine, School of Medicine"}, {"id"=>93, "code"=>"85", "original_text"=>"Columbia Faculty", "web_text"=>"Columbia Faculty", "description"=>"Full time faculty are eligible for expanded privileges by pre-registering through the <a href = \"http://marli.libguides.com/welcome\">MaRLI initiative</a>.\r\n\r\nOtherwise, Faculty have limited privileges to Bobst Library through Columbia University <a href=\"https://library.nyu.edu/about/visiting/visitor-access-to-nyu-libraries/students-and-faculty-from-other-institutions/\">Reciprocal Agreement.</a>  See Columbia University category for these privileges.\r\n", "from_aleph"=>true, "created_at"=>"2011-03-11T07:00:18.000Z", "updated_at"=>"2020-02-16T05:52:12.000Z", "visible"=>true, "id_type"=>"Join <a href = \"http://marli.libguides.com/welcome\">MaRLI</a>, then present Columbia ID to Bobst Library Privileges Office to obtain pass.", "under_header"=>"Other", "keywords"=>""}, {"id"=>92, "code"=>"84", "original_text"=>"Columbia PhD Student", "web_text"=>"Columbia PhD Student", "description"=>"Doctoral candidates are eligible for expanded privileges by pre-registering through the <a href = \"http://marli.libguides.com/welcome\">MaRLI initiative</a>.\r\n\r\nOtherwise, PhD students have limited privileges to Bobst Library through Columbia University <a href=\"https://library.nyu.edu/about/visiting/visitor-access-to-nyu-libraries/students-and-faculty-from-other-institutions/\">Reciprocal Agreement.</a>  See Columbia University category for these privileges.\r\n", "from_aleph"=>true, "created_at"=>"2011-03-11T07:00:18.000Z", "updated_at"=>"2020-02-16T05:52:12.000Z", "visible"=>true, "id_type"=>"Join <a href = \"http://marli.libguides.com/welcome\">MaRLI</a>, then present Columbia ID to Bobst Library Privileges Office to obtain pass.", "under_header"=>"Other", "keywords"=>""}, {"id"=>94, "code"=>"86", "original_text"=>"NYPL Scholar", "web_text"=>"MaRLI User", "description"=>"Manhattan Research Library Initiative (MaRLI)\r\n\r\nThe New York Public Library and the libraries of Columbia University and New York University have launched an initiative to expand access to collections and better serve their users. The collaboration, dubbed the Manhattan Research Library Initiative (MaRLI), will enable NYU and Columbia doctoral students, full-time faculty and librarians, and vetted New York Public Library cardholders with a demonstrable research need not met by currently available resources, to borrow materials from all three institutions. To apply for borrowing privileges at NYU and Columbia, please complete the online registration form. Your application will be forwarded to both institutions and your credentials will be ready for pick up in two business days. For further information about the initiative, including participating libraries, please see <a href = \"http://marli.libguides.com/welcome\">http://marli.libguides.com/welcome</a>. \r\n\r\n", "from_aleph"=>true, "created_at"=>"2011-03-11T07:00:19.000Z", "updated_at"=>"2020-03-10T21:47:02.000Z", "visible"=>true, "id_type"=>"Present photo ID to Bobst Library Privileges Office to obtain MaRLI borrowers pass. <a href = \"http://marli.libguides.com/welcome\">(Must pre-register online.)</a>", "under_header"=>"Other", "keywords"=>""}]
    end

    def attrs
      defined?(current_user) ? { patron_status: current_user.patron_status } : { patron_status: patron_status }
    end

  end

end

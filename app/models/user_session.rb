class UserSession < Authlogic::Session::Base
  pds_url Settings.login.pds_url
  calling_system Settings.login.calling_system
  anonymous true
  #redirect_logout_url Settings.login.redirect_logout_url
  
  def additional_attributes
    h = {}
    return h unless pds_user
    h[:marli_admin] = true if Settings.login.default_admins.include? pds_user.uid
    addr_info = Exlibris::Aleph::Patron.new(pds_user.nyuidn, 'http://aleph.library.nyu.edu:1891/rest-dlf').address
    h[:address] = {}
    h[:address][:street_address] = addr_info["get_pat_adrs"]["address_information"]["z304_address_2"]["__content__"]
    h[:address][:city] = addr_info["get_pat_adrs"]["address_information"]["z304_address_3"]["__content__"]
    h[:address][:state] = addr_info["get_pat_adrs"]["address_information"]["z304_address_4"]["__content__"]
    h[:address][:postal_code] = addr_info["get_pat_adrs"]["address_information"]["z304_zip"]["__content__"]
    return h
  end
  
end
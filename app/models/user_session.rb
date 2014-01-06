class UserSession < Authlogic::Session::Base
  pds_url Settings.login.pds_url
  calling_system Settings.login.calling_system
  anonymous true
  redirect_logout_url Settings.login.redirect_logout_url
  
  def additional_attributes
    h = {}
    return h unless pds_user
    h[:marli_admin] = true if Settings.login.default_admins.include? pds_user.uid
    patron = Exlibris::Aleph::Patron.new(patron_id: pds_user.nyuidn)
    addr_info = patron.address
    h[:address] = {}
    h[:address][:street_address] = addr_info["z304_address_2"]["__content__"]
    h[:address][:city] = addr_info["z304_address_3"]["__content__"]
    h[:address][:state] = addr_info["z304_address_4"]["__content__"]
    h[:address][:postal_code] = addr_info["z304_zip"]["__content__"]
    return h
  rescue Exception => e
    render 'user_sessions/unexpected_error' and return
  end
  
end
class UserSession < Authlogic::Session::Base
  pds_url (ENV['PDS_URL'] || 'https://login.library.nyu.edu')
  calling_system 'marli'
  anonymous true
  redirect_logout_url 'http://bobcat.library.nyu.edu'

  def additional_attributes
    h = {}
    return h unless pds_user
    h[:marli_admin] = true if default_admins.include? pds_user.uid
    patron = Exlibris::Aleph::Patron.new(patron_id: pds_user.nyuidn)
    addr_info = patron.address
    h[:address] = {}
    h[:address][:street_address] = addr_info["z304_address_2"]["__content__"]
    h[:address][:city] = addr_info["z304_address_3"]["__content__"]
    h[:address][:state] = addr_info["z304_address_4"]["__content__"]
    h[:address][:postal_code] = addr_info["z304_zip"]["__content__"]
    return h
  end

  private
  def default_admins
    (Figs.env['MARLI_DEFAULT_ADMINS'] || [])
  end
end

class UserSession < Authlogic::Session::Base
  pds_url (ENV['PDS_URL'] || 'https://pds.library.nyu.edu')
  calling_system 'marli'
  anonymous true
  redirect_logout_url 'http://bobcat.library.nyu.edu'

  def additional_attributes
    h = {}
    return h unless pds_user
    h[:marli_admin] = true if default_admins.include? pds_user.uid
    patron = Exlibris::Aleph::Patron.new(pds_user.nyuidn)
    address = patron.address
    h[:address] = {
      street_address: address.address2,
      city: address.address3,
      state: address.address4,
      postal_code: address.zip
    }
    return h
  end

  private
  def default_admins
    (Figs.env['MARLI_DEFAULT_ADMINS'] || [])
  end
end

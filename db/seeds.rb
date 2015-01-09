# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# require 'authlogic'
username = 'admin'
if Rails.env.development? and User.find_by_username(username).nil?
  # salt = Authlogic::Random.hex_token
  user = User.create!({
    username: username,
    firstname: 'Dev',
    lastname: 'Eloper',
    email: 'dev.eloper@library.edu',
    aleph_id: (ENV['BOR_ID'] || 'BOR_ID'),
    dob: "2014/12/01",
    barcode: "12345",
    provider: "nyulibraries",
    institution_code: "NYU",
    admin: true,
    patron_status: '51',
    override_access: false,
    school: "Bobst",
    department: "Division of Libs",
    address: {street_address: "123 Main St", city: "Des Moines", state: "Grace", postal_code: "12345"}
  })
  user.save!
end

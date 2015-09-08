# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
username = 'admin'
if Rails.env.development? and User.find_by_username(username).nil?
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

ApplicationDetail.create!(
  {
    purpose: "already_submitted",
    the_text: "You have already submitted your information",
    description: "<strong>Aready submitted:</strong> Displayed to users revisiting the application after submitting their information"
  }
)

ApplicationDetail.create!(
  {
    purpose: "body_text",
    the_text: "The New York Public Library and the libraries of Columbia University and New York University have launched an initiative to expand access to collections and better serve their users.  The collaboration, dubbed the Manhattan Research Library Initiative (MaRLI), will enable NYU and Columbia doctoral students, full-time faculty and librarians, and vetted New York Public Library cardholders with a demonstrable research need not met by currently available resources, to borrow materials from all three institutions.  To apply for or renew borrowing privileges at New York Public Library and Columbia, please complete the information below.  Your application will be forwarded to both institutions and your credentials will be ready for pick up in two business days.  For further information about the initiative, including participating libraries, please see <a href= \"http://library.nyu.edu/marli\"> http://library.nyu.edu/marli</a> .",
    description: "<strong>Body text:</strong> Displayed to users above the \"submit\" button containing information, i.e. terms, policy, etc."
  }
)

ApplicationDetail.create!(
  {
    purpose: "closed_body",
    the_text: "Application is closed",
    description: "<strong>Closed body text:</strong> Replaces the body of the application after registration is closed"
  }
)

ApplicationDetail.create!(
  {
    purpose: "closed_header",
    the_text: "Application is closed",
    description: "<strong>Closed header:</strong> Replaces the title of the application after registration is closed"
  }
)

ApplicationDetail.create!(
  {
    purpose: "subtitle",
    the_text: "Provides eligible borrowers from Columbia University, New York Public Library, and New York University with materials not available at their home institutions.",
    description: "<strong>Subtitle:</strong> Displayed to users under main title"
  }
)

ApplicationDetail.create!(
  {
    purpose: "title",
    the_text: "MaRLI: Manhattan Research Library Initiative ",
    description: "<strong>Title:</strong> Main title"
  }
)

ApplicationDetail.create!(
  {
    purpose: "default_patron_type",
    the_text: "NYU PhD Student",
    description: "<strong>Default patron stype:</strong> The default text to display as \"Affiliation\" when no mapping is available in the application"
  }
)

ApplicationDetail.create!(
  {
    purpose: "submit",
    the_text: "Submit",
    description: "<strong>Submit:</strong> Displayed on the button that prompts users to submit"
  }
)

ApplicationDetail.create!(
  {
    purpose: "confirmation_title",
    the_text: "Welcome to MaRLI!",
    description: "<strong>Confirmation title:</strong> Title displayed to the user after submitting"
  }
)

ApplicationDetail.create!(
  {
    purpose: "unauthorized_patron",
    the_text: "Sorry, your log in credentials do not indicate that you are eligible for this program. If you believe this is an error, please use the <a href=\"http://library.nyu.edu/forms/help/MaRLI_Question_Form.html\">MaRLI Questions Form</a> or review the MaRLI information located at <a href= \"http://library.nyu.edu/marli\"> http://library.nyu.edu/marli</a> .",
    description: "<strong>Unauthroized patron:</strong> Displayed to users not recognized as authorized patrons"
  }
)

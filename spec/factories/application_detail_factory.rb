FactoryBot.define do
  factory :application_detail do
    purpose "already_submitted"
    the_text "You have already submitted your information"
    description "<strong>Aready submitted:</strong> Displayed to users revisiting the application after submitting their information"
    factory :random_application_detail do
      purpose {Faker::Lorem.word}
      the_text {Faker::Lorem.sentence}
      description {Faker::Lorem.paragraph(2)}
    end
  end
end

FactoryGirl.define do
  factory :user do
    email     "user@example.com"
    password  "exampleexample"
  end
end

FactoryGirl.define do
  factory :nav_item do
    id "0"
    link_1_name "About Me"
    link_2_name "Showreel"
    link_3_name "Works"
    link_4_name "Current Projects"
    link_5_name "Contact"
  end
end

FactoryGirl.define do
  factory :about_me_content do
    id "0"
    header "header"
    description "my_description"
    button_title "my_button_title"
  end
end

FactoryGirl.define do
  factory :showreel do
    id "0"
    description "This is my description.  I hope you like it!"
    media_link "http://vimeo.com/82123812"
    media_choice "link"
    header "My Showreel"
  end
end

FactoryGirl.define do
  factory :work do |u|
    u.sequence(:id) {|n|}
    u.sequence(:description) {|n| "This is my description #{n}."}
    u.media_link "http://vimeo.com/82123812"
    u.media_choice "link"
    u.sequence(:header) {|n| "Header #{n}"}
  end
end

FactoryGirl.define do
  factory :current_project do |u|
    u.sequence(:id) {|n|}
    u.sequence(:header) {|n| "Header #{n}"}
    u.sequence(:description) {|n| "This is my description #{n}."}
    u.progress 65
    u.media_choice "link"
    u.media_link "http://vimeo.com/82123812"
  end
end

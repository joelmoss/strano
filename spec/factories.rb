FactoryGirl.define do

  factory :user do
    username Faker::Internet.user_name
    github_access_token 'somerandomstring'
  end

  factory :project do
    url 'git@github.com:joelmoss/strano.git'
  end

end
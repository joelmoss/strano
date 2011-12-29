FactoryGirl.define do

  factory :user do
    sequence :email do |n|
      "person#{n}@example.com"
    end
    github_access_token 'somerandomstring'
  end

  factory :project do
    url 'git@github.com:joelmoss/strano.git'
  end

end
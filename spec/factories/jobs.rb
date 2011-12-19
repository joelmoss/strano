# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :job do
    task "MyString"
    notes "MyText"
  end
end

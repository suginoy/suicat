# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :history do
    user nil
    card nil
    raw_data "MyText"
    from "MyString"
    to "MyString"
  end
end

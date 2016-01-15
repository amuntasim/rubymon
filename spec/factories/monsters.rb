FactoryGirl.define do
  factory :monster do
    sequence :name do |n|
      "Monster #{n}"
    end
    power "MyString"
    category "wind"
    user_id 1
  end

end

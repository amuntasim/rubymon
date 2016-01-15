FactoryGirl.define do
  factory :team do
    sequence :name do |n|
      "Team #{n}"
    end
    user_id 1
  end
end

FactoryBot.define do
  factory :notification do
    sender { create :user }
    receiver { create :user }
    micropost { create :micropost }
  end
end
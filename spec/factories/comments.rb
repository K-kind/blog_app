FactoryBot.define do
  factory :comment do
    content { 'テストコメントです' }
    user
    micropost
  end
end
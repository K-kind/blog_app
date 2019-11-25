FactoryBot.define do
  sequence :title do |n|
    "テストポスト#{n}"
  end

  factory :micropost do
    title
    content { 'テストです' }
    content_string { content.to_s }
    category { 'テスト' }
    user
  end
end
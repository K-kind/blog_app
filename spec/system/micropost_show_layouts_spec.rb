require 'rails_helper'

RSpec.describe '投稿詳細画面のレイアウト', type: :system do
  # ページの表示には管理ユーザーと最初のポストが必要
  let!(:first_user) { create(:user, admin: true) }
  let!(:first_post) { create(:micropost, title: '最初のポスト', content: '最初のポストです。', category: 'テスト', user: first_user, impressions_count: 1, created_at: Time.zone.parse('2019-11-25')) }

  let(:second_user) { create(:user) }

  context 'ログインしていない時' do
    before do
      visit micropost_path first_post
    end

    it '投稿編集、削除ボタンが表示されていないこと' do
      expect(page).not_to have_button('編集')
      expect(page).not_to have_button('削除')
    end

    it 'いいねボタンが表示されていないこと' do
      expect(page).not_to have_selector('span.glyphicon-heart')
    end

    it 'コメントができないこと' do
      expect(page).to have_selector('textarea[placeholder="コメントにはログインが必要です"]')
    end
  end

  context '一般ユーザーとしてログインしている時' do
    before do
      visit login_path
      fill_in 'session_email', with: second_user.email
      fill_in 'session_password', with: second_user.password
      click_button 'commit'
      visit micropost_path first_post
    end

    it '投稿編集、削除ボタンが表示されていないこと' do
      expect(page).not_to have_button('編集')
      expect(page).not_to have_button('削除')
    end

    it 'いいねボタンが表示されていること' do
      expect(page).to have_selector('span.glyphicon-heart')
    end

    it 'いいねの送信・削除ができること', js: true do
      expect(page).to have_content('いいね: 0')
      find('span.glyphicon-heart').click
      expect(page).to have_content('いいね: 1')
      expect(page).to have_selector('span.red-heart')
      find('span.glyphicon-heart').click
      expect(page).to have_content('いいね: 0')
      expect(page).to have_selector('span.gray-heart')
    end

    it 'コメントフォームが表示されていること' do
      expect(page).to have_selector('textarea#comment_content')
    end

    it 'コメントを送信できること' do
      fill_in 'comment_content', with: 'コメントします'
      click_button 'コメントを送信' 
      within '.comment-box' do
        expect(page).to have_content(second_user.name)
        expect(page).to have_content('コメントします')
        expect(page).to have_selector 'a', text: '編集'
        expect(page).to have_selector 'a', text: '削除'
        expect(page).to have_selector 'a', text: '返信'
      end
    end
  end
end

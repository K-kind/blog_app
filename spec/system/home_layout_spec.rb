require 'rails_helper'

RSpec.describe "ホーム画面のレイアウト", type: :system do

  # ページの表示には管理ユーザーと最初のポストが必要
  let!(:first_user) { create(:user, admin: true, introduction: '初めまして') }
  let!(:first_post) { create(:micropost, title: '最初のポスト', content: '最初のポストです。', category: 'テスト', user: first_user, impressions_count: 1, created_at: Time.zone.parse('2019-11-25')) }
  
  let(:second_user) { create(:user) }

  describe 'ヘッダーのリンク' do
    context 'ログインしていない状態でのヘッダー' do
      before do
        visit root_path
      end
      it 'ブログ概要、新規登録、ログインリンクがあること' do
        within 'header' do
          expect(page).to have_selector('a[href="/about"]')
          expect(page).to have_selector('a[href="/signup"]')
          expect(page).to have_selector('a[href="/login"]')
        end
      end
      it '新規投稿、ユーザー一覧、通知、ユーザー詳細、ログアウトリンクがないこと' do
        within 'header' do
          expect(page).not_to have_selector('a[href="/microposts/new"]')
          expect(page).not_to have_selector('a[href="/users"]')
          expect(page).not_to have_selector('a[href="/notifications"]')
          expect(page).not_to have_selector('a[href="/logout"]')
        end
      end
    end

    context '一般ユーザーログイン時のヘッダー' do
      before do
        visit login_path
        fill_in 'session_email', with: second_user.email
        fill_in 'session_password', with: second_user.password
        click_button 'commit'
        visit root_url
      end

      it '通知、ログアウトリンクがあること' do
        within 'header' do
          expect(page).to have_selector('a[href="/notifications"]')
          expect(page).to have_selector('a[href="/logout"]')
        end
      end
      it '新規投稿、ユーザー一覧、ユーザー詳細、ブログ概要、新規登録、ログインリンクがないこと' do
        within 'header' do
          expect(page).not_to have_selector('a[href="/microposts/new"]')
          expect(page).not_to have_selector('a[href="/users"]')
          expect(page).not_to have_selector('a[href="/about"]')
          expect(page).not_to have_selector('a[href="/signup"]')
          expect(page).not_to have_selector('a[href="/login"]')
        end
      end

      it '自分のプロフィール画像があること' do
        within 'header' do
          expect(page).to have_selector('img')
          expect(page).to have_content(second_user.name)
        end
      end
    end

    context '管理者ログイン時のヘッダー' do
      before do
        visit login_path
        fill_in 'session_email', with: first_user.email
        fill_in 'session_password', with: first_user.password
        click_button 'commit'
        visit root_url
      end

      it '新規投稿、ユーザー一覧、通知、ログアウトリンクがあること' do
        within 'header' do
          expect(page).to have_selector('a[href="/microposts/new"]')
          expect(page).to have_selector('a[href="/users"]')
          expect(page).to have_selector('a[href="/notifications"]')
          expect(page).to have_selector('a[href="/logout"]')
        end
      end
      it 'ブログ概要、新規登録、ログインリンクがないこと' do
        within 'header' do
          expect(page).not_to have_selector('a[href="/about"]')
          expect(page).not_to have_selector('a[href="/signup"]')
          expect(page).not_to have_selector('a[href="/login"]')
        end
      end
      it '自分のプロフィール画像があること' do
        within 'header' do
          expect(page).to have_selector('img')
          expect(page).to have_content(first_user.name)
        end
      end
    end
  end

  describe 'ページメイン' do
    context '最新のポストが2500文字より少ない場合' do
      let!(:second_post) { create(:micropost, title: '2つ目のポスト', content: 'a' * 2000, category: 'テスト2', user: first_user) }
      before do
        visit root_path
      end
      it '最新のポストが2つ表示されていること' do
        expect(page).to have_content('a' * 2000)
        expect(page).to have_content('最初のポストです')
      end
    end
    context '最新のポストが2500文字以上の場合' do
      let!(:second_post) { create(:micropost, title: '2つ目のポスト', content: 'a' * 2500, category: 'テスト2', user: first_user) }
      before do
        visit root_path
      end
      it '最新のポストが1つだけ表示されていること' do
        expect(page).to have_content('a' * 2500)
        expect(page).not_to have_content('最初のポストです')
      end
    end
  end

  describe 'サイド情報のレイアウト' do
    before do
      visit root_path
    end
    it '管理ユーザーの情報が表示されていること' do
      within '.user-info' do
        expect(page).to have_content(first_user.name)
        expect(page).to have_selector('img')
        expect(page).to have_content(first_user.introduction)
        expect(page).to have_selector('a[href="/about"]')
      end
    end

    it '人気記事一覧が表示されていること' do
      within '.popular-posts' do
        expect(page).to have_content(first_post.title)
      end
    end

    context 'ドロップダウンメニューをクリックした時' do
      it 'アーカイブが表示されること', js: true do
        within '.post-menus' do
          click_on '月別アーカイブ'
          expect(page).to have_content('2019年11月')
        end
      end

      it 'カテゴリーが表示されること', js: true do
        within '.post-menus' do
          click_on 'カテゴリー'
          expect(page).to have_content(first_post.category)
        end
      end
    end
  end
end

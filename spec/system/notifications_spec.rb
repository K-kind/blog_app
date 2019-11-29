require 'rails_helper'

RSpec.describe '通知機能', type: :system, js: true do
  let!(:first_user) { create(:user, admin: true) }
  let!(:first_post) { create(:micropost, user: first_user) }
  let!(:second_user) { create(:user) }
  let!(:first_comment) { create(:comment, user: first_user, micropost: first_post) }
  context '一般ユーザーがいいね1、コメント3件を送る' do
    before do
      # 一般ユーザーとしてログイン
      visit login_path
      fill_in 'session_email', with: second_user.email
      fill_in 'session_password', with: second_user.password
      click_button 'commit'
      visit micropost_path first_post
      # いいねを送信
      find('span.glyphicon-heart').click
      # first_userのコメントに返信
      find('a.reply-btn').click
      within '.comment-list' do
        fill_in 'comment_content', with: 'first_userのコメントへの返信'
        find('.comment-btn').click
      end
      # コメントを送信
      fill_in 'comment_content', with: 'second_userのコメント'
      click_button 'コメントを送信' 
      # 自分のコメントに返信
      within page.all('.comment-list')[1] do
        find('a.reply-btn').click
        fill_in 'comment_content', with: 'second_user自身のコメントへの返信'
        find('.comment-btn').click
      end
    end
      
    it '一般ユーザー自身に通知が来ていないこと' do
      within 'header' do
        expect(page).to have_selector 'span', text: '0'
      end
    end

    context '管理ユーザーに正しく通知が来ていること' do
      before do
        find('a[href="/logout"]').click
        visit login_path
        fill_in 'session_email', with: first_user.email
        fill_in 'session_password', with: first_user.password
        click_button 'commit'
      end
      it '4件の通知が来ていること' do
        within 'header' do
          expect(page).to have_selector 'span', text: '4'
        end
      end
      it '通知の内容が正しいこと' do
        find('a[href="/notifications"]').click
        expect(page).to have_content( "#{second_user.name}さんが<#{first_post.title}>にいいねしました")
        expect(page).to have_content('first_userのコメントへの返信')
        expect(page).to have_content( "#{second_user.name}さんが<#{first_post.title}>にコメントしました")
        expect(page).to have_content('second_user自身のコメントへの返信')
      end

      context '一般ユーザーへの通知' do
        before do
          visit micropost_path first_post
          # second_userのコメントに返信
          within page.all('.comment-list')[1] do
            find('a.reply-btn').click
            fill_in 'comment_content', with: 'second_userのコメントへの返信'
            find('.comment-btn').click
          end
          # second_userにログイン
          find('a[href="/logout"]').click
          visit login_path
          fill_in 'session_email', with: second_user.email
          fill_in 'session_password', with: second_user.password
          click_button 'commit'
        end
        it '一般ユーザーに通知が来ていること' do
          within 'header' do
            expect(page).to have_selector 'span', text: '1'
          end
          find('a[href="/notifications"]').click
          expect(page).to have_content('second_userのコメントへの返信')
        end
      end
    end
  end
end

require 'rails_helper'

describe 'ユーザー関連機能', type: :system do
  let!(:first_user) { create(:user) }
  let!(:first_post) { create(:micropost) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  describe '新規登録' do
    context '無効な情報' do
      before do
        @user_count = User.count
        visit signup_path
        fill_in 'user_name', with: ''
        fill_in 'user_email', with: 'user@invalid'
        fill_in 'user_password', with: 'foo'
        fill_in 'user_password_confirmation', with: 'foo'
        click_button 'commit'
      end

      it 'エラーメッセージが表示される' do
        expect(page).to have_selector 'div.alert-danger'
      end

      it '無効なユーザーは登録されていない' do
        expect(User.count).to eq(@user_count)
      end
    end

    context '有効な情報' do
      before do
        @user_count = User.count
        @user = assigns(:user)
        visit signup_path
        fill_in 'user_name', with: 'Example User'
        fill_in 'user_email', with: 'user@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_button 'commit'
      end

      it 'メール発送通知が表示される' do
        expect(page).to have_selector 'div.alert-info'
      end

      it 'メールが発送される' do
        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end

      it 'ユーザーが保存される' do
        expect(User.count).to eq(@user_count + 1)
      end
      
      it 'ユーザーはまだ有効化されていない' do
        expect(@user.activated?).to be_falsey
      end

      it '有効化していないユーザーはログインできない' do
        visit login_path
        fill_in 'session_email', with: 'user@example.com'
        fill_in 'session_password', with: 'password'
        click_button 'commit'
        expect(current_user).to be_falsey
      end

    end
  end
end